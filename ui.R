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
