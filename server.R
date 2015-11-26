library(data.table)
library(curl)
library(devtools)
library(rio)

enero <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/1.csv')
febrero <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/2.csv')
marzo <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/3.csv')
abril <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/4.csv')
mayo <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/5.csv')
junio <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/6.csv')
julio <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/7.csv')
agosto <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/8.csv')
septiembre <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/9.csv')
octubre <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/10.csv')
noviembre <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/11.csv')
diciembre <- import('https://raw.githubusercontent.com/cheespanther/SMTicketSalesApp/master/datos/12.csv')

library(shiny)
library(datasets)
library(plyr)

# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
  
  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "enero" = enero,
           "febrero" = febrero,
           "marzo" = marzo,
           "abril" = abril,
           "mayo" = mayo,
           "junio" = junio,
           "julio" = julio,
           "agosto" = agosto, 
           "septiembre" = septiembre,
           "octubre" = octubre,
           "noviembre" = noviembre,
           "diciembre" = diciembre
           )
  })
  
  # Generate a summary of the dataset
  
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  output$rangotickets <- renderPrint({
    dataset <- datasetInput()
    analisisticketsmensual <- function(dataset)
    {
      
      numerodatos <<- nrow(dataset)
      datatickets <<- c(dataset$amount_total, na.rm= TRUE)
      soloventas <<- subset (datatickets, datatickets > 0)
      
      ventastotales <<- sum(soloventas)
      combinedmean <<- mean(soloventas)
      ventamin <<- min(soloventas)
      ventamax <<- max(soloventas)   
      
      dataticketsplit <<- split(dataset, dataset$session_id.user_id.display_name)
      dataticketsplit2 <<- list2env(dataticketsplit, envir = .GlobalEnv)
      
      c1 <- as.matrix(subset (soloventas, soloventas <= 20))
      c2 <- as.matrix(subset (soloventas, soloventas > 20 & soloventas <= 50))
      c3 <- as.matrix(subset (soloventas, soloventas > 50 & soloventas <= 100))
      c4 <- as.matrix(subset (soloventas, soloventas > 100 & soloventas <= 200))
      c5 <- as.matrix(subset (soloventas, soloventas > 200 & soloventas <= 400))
      c6 <- as.matrix(subset (soloventas, soloventas > 400))
      
      cuentas1 <- nrow(c1)
      cuentas2 <- nrow(c2)
      cuentas3 <- nrow(c3)
      cuentas4 <- nrow(c4)
      cuentas5 <- nrow(c5)
      cuentas6 <- nrow(c6)
      Frecuencia <- c(cuentas1, cuentas2, cuentas3, cuentas4, cuentas5, cuentas6)
      Clases <- c("Menor a $20.00", "$21.00 a $50.00", "$51.00 a $100.00",
                  "$101.00 a $200.00", "$201.00 a $400.00", "Mayor a $400.00")
      
      tabla <<- data.frame(Clases, Frecuencia)
      tablabonita <<- format (tabla, width = 20, justify = "right")
      
      tablabonita
      
    }
    analisisticketsmensual(dataset)
    
  })
  
  output$resumen <- renderPrint({
    
    dataset <- datasetInput()
    
    resumen <<- c(numerodatos, ventastotales, combinedmean, ventamin, ventamax)
    resumentitle <- c("Numero de Tickets", "Ventas Totales", "Promedio de Venta", "Venta Baja", "Venta Alta") 
    resumentabla <<- data.frame(resumentitle, resumen)  
    resumentabla
    
    })
  
  output$cajeros <- renderPrint({
    
    dataset <- datasetInput()
    
    promedio_cajeros <<- ddply (dataset, "session_id.user_id.display_name", summarise, promediocajero = mean(amount_total))
    numero_de_ventas <<- ddply (dataset, "session_id.user_id.display_name", summarise, ticketstotal = length(amount_total))
    suma_cajeros <<- ddply (dataset, "session_id.user_id.display_name", summarise, ventatotal = sum(amount_total))
    cajeros <<- cbind(promedio_cajeros, numero_de_ventas[,2], suma_cajeros[,2])
    colnames(cajeros) <<- c("Cajero", "Promedio", "No. de Ventas", "Total Ventas")
    cajeros
    
  })


  # Show the first "n" observations
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
})
