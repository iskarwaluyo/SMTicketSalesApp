library(data.table)
library(curl)

enero <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/1.csv', sep = '\n')
febrero <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/2.csv', sep = '\n')
marzo <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/3.csv', sep = '\n')
abril <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/4.csv', sep = '\n')
mayo <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/5.csv', sep = '\n')
junio <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/6.csv', sep = '\n')
julio <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/7.csv', sep = '\n')
agosto <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/8.csv', sep = '\n')
septiembre <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/9.csv', sep = '\n')
octubre <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/10.csv', sep = '\n')
noviembre <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/11.csv', sep = '\n')
diciembre <- fread('https://github.com/cheespanther/SMTicketSalesApp/blob/master/datos/12.csv', sep = '\n')

library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title.
  headerPanel("Resumen Ventas por Ticket"),
  
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view. The helpText function is also used to 
  # include clarifying text. Most notably, the inclusion of a 
  # submitButton defers the rendering of output until the user 
  # explicitly clicks the button (rather than doing it immediately
  # when inputs change). This is useful if the computations required
  # to render output are inordinately time-consuming.
  
  sidebarPanel(
    selectInput("dataset", "Elige un mes para revisar:", 
                choices = c("enero", "febrero", "marzo", "abril", "mayo", "junio", "agosto", 
                            "septiembre", "octubre", "noviembre", "diciembre")),
    
    numericInput("obs", "Numero de Tickets Visibles:", 10),
    
    helpText("Note: while the data view will show only the specified",
             "number of observations, the summary will still be based",
             "on the full dataset."),
    
    submitButton("Actualizar Vista"),
    
    h4("Rango Tickets:"),
    verbatimTextOutput("rangotickets"),
    
    h4("Resumen General:"),
    verbatimTextOutput("resumen")
    
  ),
  
  # Show a summary of the dataset and an HTML table with the requested
  # number of observations. Note the use of the h4 function to provide
  # an additional header above each output section.
  mainPanel(

    h4("Resumen Cajeros:"),
    verbatimTextOutput("cajeros"),
    
    h4("Datos Tickets:"),
    tableOutput("view")

  )
))
