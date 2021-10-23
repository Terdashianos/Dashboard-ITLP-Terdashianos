
###library(rworldxtra)
###library(tidyverse)
###library(sf)
###library(raster)

pacman::p_load(bslib, shiny, shinydashboard, tidyverse, shinythemes, highcharter, zoo, readxl, shinyWidgets,
               leaflet, sf, viridis, RColorBrewer, dplyr, htmlwidgets, leaflet.providers, haven, leaflet, leaflet.extras,
               rworldxtra, raster, paletteer, rcartocolor)

ITLP_mother_base <- read_excel("www/ITLP_mother_base.xlsx")
transfer_ej <- read_excel("www/transfer_ej.xlsx")
m_desemp <- read_excel("www/m_ejercido_desemp.xlsx")
programas_cdmx <- read_excel("www/Programas_cdmx.xlsx")
Programas_cdmx_presupuesto <- read_excel("www/Programas_cdmx_presupuesto.xlsx")
nbi <- read_excel("www/nbi.xlsx")
transferencias_ds <- read_excel("www/transferencias_ds.xlsx")
aprobado <- read_excel("www/aprobado.xlsx")
ejercido <- read_excel("www/ejercido.xlsx")
desempleo_aprobado <- read_excel("www/desempleo_aprobado.xlsx")
desempleo_ejercido <- read_excel("www/desempleo_ejercido.xlsx")
alcaldias_desmpleo <- read_excel("www/alcaldias_desmpleo.xlsx")

### cambiale la direccion

shape_est <- st_read("www/sin_islas.shp")
shape_mun <- st_read("www/MUNICIPIOS.shp")
sol_ciudad <- read_dta("www/base solicitudes ciudad.dta")
pobreza_ciudad <- read_dta("www/MAPAS PARA ALCALDIAS.dta")


as.yearqtr(ITLP_mother_base$fecha)




###################################################################################################################
######################################################### ui ######################################################
###################################################################################################################


ui<-dashboardPage(title = "Datatón", skin= "purple",
  dashboardHeader(title = "Datatón ITLP",
                  dropdownMenu(type = "notifications",
                               notificationItem(text = "Repositorio con el codigo de la aplicacion", href="https://github.com/Terdashianos/Dashboard-ITLP-Terdashianos.git"),
                               icon = shiny::icon("cat"))),
  dashboardSidebar(collapsed = TRUE,
                   sidebarMenu(id="sidebarID",
                               menuItem("Introduccion", icon = shiny::icon("journal-whills"),
                                        menuSubItem("Planteamiento", tabName = "intro1", icon = shiny::icon("book-reader")),
                                        
                                        menuSubItem("Método", tabName = "method", icon = shiny::icon("people-carry"))
                                        ),
                                        
                               menuItem("Pobreza laboral", icon = shiny::icon("journal-whills"),
                                        menuSubItem("Por Genero", tabName = "gen", icon = shiny::icon("venus-mars")),
                                        menuSubItem("Por Educacion", tabName = "edu", icon = shiny::icon("user-graduate")),
                                        menuSubItem("Por posicion", tabName = "pos", icon = shiny::icon("address-card")),
                                        menuSubItem("Por Acceso a SS", tabName = "seg", icon = shiny::icon("star-of-life"))                                        ),
                               menuItem("Gasto y seguridad social", icon = shiny::icon("journal-whills"),
                                        menuSubItem("Transferencias a Alcaldias", tabName = "transfer", icon = shiny::icon("funnel-dollar")),
                                        menuSubItem("Gasto en desempleo",tabName = "gdes", icon = shiny::icon("search-dollar")),
                                        menuSubItem("Solicitudes de desempleo", tabName = "maps", icon = shiny::icon("users")),
                                        menuSubItem("Seguridad social", tabName = "ss", icon = shiny::icon("star-of-life"))
                                        ),
                               menuItem("Equipo", icon = shiny::icon("users"),
                                        menuSubItem("Equipo", tabName = "Equipo", icon = shiny::icon("users"))
                                        )
                               )
                        ),
  


  dashboardBody(
            tabItems(tabItem(tabName= "intro1",
                     title = "Pobreza laboral en la CDMX",
                     fluidRow(
                       column(
                         5, sidebarPanel(
                           pickerInput("radio1","Método", choices=list("Hotdeck"=0, "Salarios Mínimos"=1, "Mean Matching"=2), 
                                       selected = 0, options = list(`actions-box` = TRUE),multiple = FALSE), width=30
                         )
                         #radioButtons("radio1", label = h4(strong('MÃ©todo')),
                          #               choices = list( "Hotdeck"=0, "Salarios Mnimos"=1, "MM"=2),  
                           #              selected = 0)
                       ), 
                       column(
                         6, sliderInput("slider1", label = h4("Años"), min = 2005,
                                        max = 2021, value = c(2005, 2021), width=450)
                       )
                     ),
                     highchartOutput("intro1"),
                     h3("¿Qué es la pobreza laboral?", align = "center"),
                     br(),
                     p("La pobreza laboral es una situación en la que el ingreso laboral de un hogar no es 
                       suficiente para alimentar a todos sus miembros. Hogares en pobreza laboral pueden lograr 
                       alimentarse a partir de ingresos no laborales como remesas, transferencias o acceso a 
                       programas sociales. (México ¿Cómo Vamos?, 2021). Derivado de la crisis por la pandemia 
                       resulta interesante observar los efectos sobre este indicador. Según la Organización Internacional del Trabajo (OIT), 
                       a partir de 2017 la participación laboral fue en aumento en México, esto debido probablemente al 
                       aumento de la actividad laboral de las mujeres."),
                     br(),
                     p("En este trabajo se planteó observar las variaciones en la pobreza laboral (ITLP) principalmente a través 
                     del género auque se añaden diferentes segmentaciones para contextualizar mejor la situación, 
                     en general 
                     esta presentación se divide en tres partes:"),
                     br(),
                     "● Introducción: se describen las bases empleadas así como los métodos seguidos",
                     br(),
                     "● Pobreza laboral: Presentación de los diferentes cálculos por segmentos",
                     br(),
                     "● Gasto y programas: Una visualización sobre las acciones de la CDMX para contrarrestar el golpe de la crisis",
                     br(),
                     h3("¿Por qué diferenciar la pobreza laboral por género?", align = "center"),
                     p("Según la OIT, este aumento en la participación económica de las mujeres no ha reflejado una brecha significativa a nivel global,
                       aun están presentes algunas brechas de acceso y de oferta de empleo, es especial para algunos grupos específicos.
                       Siguiendo esta idea se torna importante mostrar si existe un efecto diferenciado de la crisis
                       entre hombres y mujeres respectivo a la pobreza laboral, esto permitirá tomar consideraciones
                       al momento de asignar recursos en la Ciudad de México."),
                     img(src = "www/dataton.PNG", height = 72, width = 72)
                     ),
                     ######################################GENDER########################################
                     tabItem(tabName= "gen",
                             title = "Pobreza laboral por género",
                             fluidRow(
                               column(
                                 5, sidebarPanel(
                                   pickerInput("radio2","Método", choices=list( "Hotdeck"=0, "Salarios Mínimos"=1, "Mean Matching"=2), 
                                               selected = 0, options = list(`actions-box` = TRUE),multiple = FALSE), width=30
                                 )
                               ), 
                               column(
                                 6, sliderInput("slider2", label = h4("Años"), min = 2005,
                                                max = 2021, value = c(2005, 2021), width=450)
                               )
                             ),
                             highchartOutput("gen"),
                             h3("Efectos diferenciados de la pandemia", align = "center"),
                             br(),
                             p("A inicios del 2020 la pobreza laboral aumentó significativamente en poco tiempo, aumentando mucho más rápido para las mujeres. Es a inicios del 2021 que comienza una recuperación progresiva para ambos grupos, aunque esta recuperación no se da con la misma velocidad. Poniendo especial atención al método de Salarios Mínimos es donde más queda marcada esta diferencia. La disminución del ITLP se da de forma mucha más lenta, incluso llegando a mantenerse por encima de niveles históricos anteriores al 2020. Con estos datos se muestra, en primera instancia, que la crisis derivada de la pandemia ha tenido efectos diferenciados entre hombres y mujeres en el mercado laboral, tanto en la intensidad, así como en el tiempo de recuperación.")
                     ),
                     ######################################EDUCATION########################################
                     tabItem(tabName= "edu",
                             title = "Pobreza laboral según el último grado de estudios",
                             fluidRow(
                               column(
                                 5, sidebarPanel(
                                   pickerInput("radio3","Método", choices=list( "Hotdeck"=0, "Salarios Mínimos"=1, "Mean Matching"=2), 
                                               selected = 0, options = list(`actions-box` = TRUE),multiple = FALSE), width=30
                                 )
                               ), 
                               column(
                                 6, sliderInput("slider3", label = h4("Años"), min = 2005,
                                                max = 2021, value = c(2005, 2021), width=450)
                               )
                             ),
                             highchartOutput("edu"),
                             h3("Pobreza laboral y nivel educaivo", align = "center"),
                             br(),
                             p("Se dividió a la población en cinco segmentos, personas que no terminaron la primaria, personas que terminaron la primaria, que terminaron la secundaria, que terminaron el nivel medio superior o educación técnica y personas que terminaron la universidad o algún posgrado. Históricamente el segmento <Primaria fue el de la población más vulnerable teniendo los niveles más altos de pobreza laboral, el segmento de Primaria es el segundo con los niveles históricos más altos. Los tres segmentos restantes se mantienen cercanos, con la población que termina educación superior tendiendo a tener los niveles más bajos de pobreza laboral. Es a inicios del 2020 que la pobreza laboral aumenta para todos los segmentos, la diferenciación comienza en el 3er trimestre del 2020 cuando los niveles de pobreza laboral tienden a disminuir para los segmentos Secundaria, Medio superior y Universidad, mientras que los otros dos dejan de aumentar. En cualquier método se observa un mismo resultado, solo el grupo Universidad y posgrado ha logrado normalizar su nivel de pobreza laboral teniendo niveles a los presentados antes del 2020, el resto de grupos aún no se recuperan por completo.")
                     ),
                     ######################################Position########################################
                    
                     tabItem(tabName= "pos",
                             title = "Pobreza laboral por posición en el trabajo",
                             fluidRow(
                               column(
                                 5, sidebarPanel(
                                   pickerInput("radio4","Método", choices=list( "Hotdeck"=0, "Salarios Mínimos"=1, "Mean Matching"=2), 
                                               selected = 0, options = list(`actions-box` = TRUE),multiple = FALSE), width=30
                                 )
                               ), 
                               column(
                                 6, sliderInput("slider4", label = h4("Años"), min = 2005,
                                                max = 2021, value = c(2005, 2021), width=450)
                               )
                             ),
                             highchartOutput("pos"),
                             h3("Pobreza laboral según la posición", align = "center"),
                             br(),
                             p("Para esta sección se divide a la población en tres segmentos según su posición en su trabajo, pueden ser Subordinados remunerados, Empleadores o Trabajadores por cuenta propia.
                               En esta gráfica se puede observar que los datos son un poco más variantes. Los niveles históricos más altos de pobreza laboral los tienen los trabajadores por cuenta propia,
                               mientras que los empleadores tienen los niveles más bajos. Es a partir de 2020 que se comienzan a observar los efectos de la crisis por la pandemia, afectando fuertemente a
                               trabajadores subordinados y empleadores alcanzando estos últimos su nivel más alto en pobreza laboral. Esto puede deberse al cierre de múltiples pequeños negocios en
                               la Ciudad de México.")
                     ),
                     ######################################Social########################################
                     
                     tabItem(tabName= "seg",
                             title = "Pobreza laboral por posición en el trabajo",
                             fluidRow(
                               column(
                                 5, sidebarPanel(
                                   pickerInput("radio5","Método", choices=list( "Hotdeck"=0, "Salarios Mínimos"=1, "Mean Matching"=2), 
                                               selected = 0, options = list(`actions-box` = TRUE),multiple = FALSE), width=30
                                 )
                               ), 
                               column(
                                 6, sliderInput("slider5", label = h4("Años"), min = 2005,
                                                max = 2021, value = c(2005, 2021), width=450)
                               )
                             ),
                             highchartOutput("seg"),
                             h3("Pobreza laboral y acceso a seguridad social", align = "center"),
                             br(),
                             p("los niveles de pobreza laboral según el acceso a seguridad social, después del primer trimestre del 2020 la pobreza laboral para personas que cuentan con acceso a seguridad social aumenta mucho más rápido que su contraparte.")
                     ),
                     
                     ######################################transfer########################################
                     
                     tabItem(tabName = "transfer",
                             title = "Transferencias a alcaldías para desarrollo social",
                             fluidRow(
                               column(
                                 1, radioButtons("radio_t", label = h4(strong('Año')),
                                                choices = list( "2018"=0, "2019"=1, "2020"=2),  
                                                selected = 0)
                               ),
                               column(
                                 10, highchartOutput("transfer")
                               )
                             ),
                             h3("Pobreza laboral y acceso a seguridad social", align = "center"),
                             br(),
                             p("Transferencias realizadas a alcaldías durante 2020 para atender el deje de desarrollo social, de forma histórica una de las alcaldías con mayores transferencias es Iztapalapa")
                             
                             
                     ),
                     
                     
                     
                     #radioButtons("radio1", label = h4(strong('MÃ©todo')),
                     #               choices = list( "Hotdeck"=0, "Salarios Mnimos"=1, "MM"=2),  
                     #              selected = 0)
                     ######################################gasto des########################################
                     
                     tabItem(tabName= "gdes",
                             title = "Monto ejercido con subfunción para combatir el desempleo",
                             fluidRow(
                               column(
                                 1, radioButtons("radio_des", label = h4(strong('Año')),
                                                 choices = list( "2018"=0, "2019"=1, "2020"=2, "2021"=3),  
                                                 selected = 0)
                               ),
                               column(
                                 10, highchartOutput("gdes")
                               ),
                               column(
                                 12, h3("", align = "center")
                               )
                             ),
                             h3("Gastos en contrarrestar el desempleo", align = "center"),
                             br(),
                             p("Egresos ejercidos por las dos principales unidades que combaten el desempleo, en 2020 el monto ejercido supera por mucho al aprobado a raíz de la pandemia, a esto se le deben sumar 26.6 millones de pesos transferidos de forma directa a las alcaldías para el mismo fin")
                     ),
                     ######################################MAPS########################################
                     
                     tabItem(tabName = "maps",
                       title = "Solicitudes de desempleo",
                       leafletOutput("maps"),
                       br(),
                       p("Las alcaldías con más solicitudes aprobadas son Xochimilco e Iztapalapa, en contraste son Cuajimalpa y la Magdalena Contreras que tienen el menor número de solicitudes aprobadas")
                     ),
                     
                     ######################################ss########################################
                     
                     tabItem(tabName= "ss",
                             title = "Seguridad social en la CDMX",
                             fluidRow(
                               column(
                                 12, highchartOutput("ss1")
                               ),
                               column(
                                 12, h4("Programas sociales en la Ciudad de Méxio"),
                                 br(),
                                 p("Estos son los programas sociales vigentes que atienden el derecho al trabajo y derechos humanos laborales, el programa con mayor alcance es el seguro de desempleo y de ellos solo dos programas toman en cuenta aspectos de género que son; jefas de familia para su inclusión laboral con un presupuesto de $11,520,000 de pesos y 900 beneficiarias y La Empleadora con un presupuesto de $99,990,000 de pesos y 7,809 beneficiarias.")
                               )),
                             fluidRow(
                               column(
                                 6, highchartOutput("ss2")
                               ),
                               column(
                                 6, h4("Presupuesto por programa"),
                                 p("El seguro de desempleo fue el programa que más recursos públicos consumió, un total de 500 millones de pesos, seguido por el programa La empleadora con 99.9 millones de pesos y fomento al trabajo digno, con 51.7 millones")
                               
                                 )
                             ),
                             
                            fluidRow(
                              column(
                                6, highchartOutput("ss3")
                              ),
                              column(
                                6, h4("Índice de Desarrollo Social en la Ciudad"),
                                   p("La población se concentra en los estratos medios y en pobreza moderada, habiendo una ligera cantidad mayor de mujeres que de hombres, el estrato alto es el único con más hombres que mujeres")
                              )
                             ),
                             
                     ),
                     
                     tabItem(tabName = "method",
                             h2("Métodos de imputación", align = "center"),
                             p(""),
                             p(""),
                             h3("Hotdeck"),
                             p("La imputación por Hotdeck implica reemplazar los valores faltantes de una o más variables para un no encuestado (llamado receptor) con valores observados de un encuestado (el donante) que es similar al no encuestado con respecto a las características observadas por ambos casos."),
                             p(""),
                             p(""),
                             h3("Match por promedios predictivos (Mean Matching)"),
                             p("Para cada entrada faltante, el m?todo forma un peque?o conjunto de donantes candidatos (generalmente con 3, 5 o 10 miembros) a partir de todos los casos completos que han predicho valores más cercanos al valor predicho para la entrada faltante. Un donante se extrae al azar de los candidatos, y el valor observado del donante se toma para reemplazar el valor faltante. La suposición es que la distribución de la ''celda'' faltante es la misma que los datos observados de los donantes candidatos."),
                             p(""),
                             p(""),
                             h3("Salarios Minimos"),
                             p("Se utilizo la metodologia empleada por CONEVAL que emplea los salarios minimos para el calculo de la pobreza laboral"),
                             p(""),
                             ),
                     tabItem(tabName = "Equipo",
                              h1("DATATON. Tu dinero, tus datos", align = "center"),
                              br(),
                              h3("Equipo: Terdashianos",br(),"El efecto de la pandemia sobre la Pobreza laboral", align = "center")
                     )
                     
                ))

)

    



###################################################################################################################
####################################################### Server ####################################################
###################################################################################################################


server <-function(input, output){
  
  ####################################################Introduction##############################################
  
  output$intro1 <- renderHighchart({
    ITLP_mother_base1<-ITLP_mother_base%>%
    filter(year>=input$slider1[1] & year<=input$slider1[2])
    if(input$radio1==0){
      h2<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral en la CDMX</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base1$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="Rural",
          data = ITLP_mother_base1$HT_TLPr, tittle=list(text="Rural"),
          color = "#5cbf39 "
        ) %>%
        hc_add_series(
          name="Urbana",
          data = ITLP_mother_base1$HT_TLPu, tittle=list(text="Urbana"),
          color = "#c45c55"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }

    if(input$radio1==1){
      h2<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral en la CDMX</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base1$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))) %>%
        hc_add_series(
          name="Rural",
          data = ITLP_mother_base1$SM_TLPr, tittle=list(text="Rural"),
          color = "#5cbf39 "
        ) %>%
        hc_add_series(
          name="Urbana",
          data = ITLP_mother_base1$SM_TLPu, tittle=list(text="Urbana"),
          color = "#c45c55"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    if(input$radio1==2){
      h2<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral en la CDMX</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base1$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))) %>%
        hc_add_series(
          name="Rural",
          data = ITLP_mother_base1$MM_TLPr, tittle=list(text="Rural"),
          color = "#5cbf39 "
        ) %>%
        hc_add_series(
          name="Urbana",
          data = ITLP_mother_base1$MM_TLPu, tittle=list(text="Urbana"),
          color = "#c45c55"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    h2
    
  })
  
  ##################################################ITLP gender####################################################
  
  output$gen <- renderHighchart({
    ITLP_mother_base2<-ITLP_mother_base%>%
      filter(year>=input$slider2[1] & year<=input$slider2[2])
    if(input$radio2==0){
      h3<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por Género</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base2$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))) %>%
        hc_add_series(
          name="Mujeres",
          data = ITLP_mother_base2$HT_TLPmuj, tittle=list(text="Mujeres"),
          color = "#d52f56 "
        ) %>%
        hc_add_series(
          name="Hombres",
          data = ITLP_mother_base2$HT_TLPhom, tittle=list(text="Hombres"),
          color = "#c1d93e"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    if(input$radio2==1){
      h3<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por Género</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base2$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="Mujeres",
          data = ITLP_mother_base2$SM_TLPmuj, tittle=list(text="Mujeres"),
          color = "#d52f56 "
        ) %>%
        hc_add_series(
          name="Hombres",
          data = ITLP_mother_base2$SM_TLPhom, tittle=list(text="Hombres"),
          color = "#c1d93e"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    if(input$radio2==2){
      h3<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por Género</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base2$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="Mujeres",
          data = ITLP_mother_base2$MM_TLPmuj, tittle=list(text="Mujeres"),
          color = "#d52f56 "
        ) %>%
        hc_add_series(
          name="Hombres",
          data = ITLP_mother_base2$MM_TLPhom, tittle=list(text="Hombres"),
          color = "#c1d93e"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    h3
  })
  
  ##################################################ITLP edu####################################################
  
  output$edu <- renderHighchart({
    ITLP_mother_base3<-ITLP_mother_base%>%
      filter(year>=input$slider3[1] & year<=input$slider3[2])
    if(input$radio3==0){
      h4<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por Educación</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base3$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))) %>%
        hc_add_series(
          name="< Primaria",
          data = ITLP_mother_base3$HT_TLPedu1, tittle=list(text="< Primaria"),
          color = "#FFFFFF"
        ) %>%
        hc_add_series(
          name="Primaria",
          data = ITLP_mother_base3$HT_TLPedu2, tittle=list(text="Primaria"),
          color = "#da4735"
        ) %>%
        hc_add_series(
          name="Secundaria",
          data = ITLP_mother_base3$HT_TLPedu3, tittle=list(text="Secundaria"),
          color = "#806ca5"
        ) %>%
        hc_add_series(
          name="Medio superior",
          data = ITLP_mother_base3$HT_TLPedu4, tittle=list(text="Medio superior"),
          color = "#85af51"
        ) %>%
        hc_add_series(
          name="Universidad y posgrado",
          data = ITLP_mother_base3$HT_TLPedu5, tittle=list(text="Universidad y posgrado"),
          color = "#3e6370"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    if(input$radio3==1){
      h4<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por Educación</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base3$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))) %>%
        hc_add_series(
          name="< Primaria",
          data = ITLP_mother_base3$SM_TLPedu1, tittle=list(text="< Primaria"),
          color = "#FFFFFF"
        ) %>%
        hc_add_series(
          name="Primaria",
          data = ITLP_mother_base3$SM_TLPedu2, tittle=list(text="Primaria"),
          color = "#da4735"
        ) %>%
        hc_add_series(
          name="Secundaria",
          data = ITLP_mother_base3$SM_TLPedu3, tittle=list(text="Secundaria"),
          color = "#806ca5"
        ) %>%
        hc_add_series(
          name="Medio superior",
          data = ITLP_mother_base3$SM_TLPedu4, tittle=list(text="Medio superior"),
          color = "#85af51"
        ) %>%
        hc_add_series(
          name="Universidad y posgrado",
          data = ITLP_mother_base3$SM_TLPedu5, tittle=list(text="Universidad y posgrado"),
          color = "#3e6370"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    if(input$radio3==2){
      h4<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por Educación</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base3$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="< Primaria",
          data = ITLP_mother_base3$MM_TLPedu1, tittle=list(text="< Primaria"),
          color = "#FFFFFF"
        ) %>%
        hc_add_series(
          name="Primaria",
          data = ITLP_mother_base3$MM_TLPedu2, tittle=list(text="Primaria"),
          color = "#da4735"
        ) %>%
        hc_add_series(
          name="Secundaria",
          data = ITLP_mother_base3$MM_TLPedu3, tittle=list(text="Secundaria"),
          color = "#806ca5"
        ) %>%
        hc_add_series(
          name="Medio superior",
          data = ITLP_mother_base3$MM_TLPedu4, tittle=list(text="Medio superior"),
          color = "#85af51"
        ) %>%
        hc_add_series(
          name="Universidad y posgrado",
          data = ITLP_mother_base3$MM_TLPedu5, tittle=list(text="Universidad y posgrado"),
          color = "#3e6370"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    h4
  })
  
  ##################################################ITLP pos####################################################
  
  output$pos <- renderHighchart({
    ITLP_mother_base4<-ITLP_mother_base%>%
      filter(year>=input$slider4[1] & year<=input$slider4[2])
    if(input$radio4==0){
      h5<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por Posición</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base4$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="Subordinado Remunerado",
          data = ITLP_mother_base4$HT_TLPpos_ocu1, tittle=list(text="Subordinado Remunerado"),
          color = "#8be137"
        ) %>%
        hc_add_series(
          name="Empleador",
          data = ITLP_mother_base4$HT_TLPpos_ocu2, tittle=list(text="Empleador"),
          color = "#54a9b3"
        ) %>%
        hc_add_series(
          name="Cuenta Propia",
          data = ITLP_mother_base4$HT_TLPpos_ocu3, tittle=list(text="Cuenta Propia"),
          color = "#da7b3e"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    if(input$radio4==1){
      h5<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por Posición</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base4$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="Subordinado Remunerado",
          data = ITLP_mother_base4$SM_TLPpos_ocu1, tittle=list(text="Subordinado Remunerado"),
          color = "#8be137"
        ) %>%
        hc_add_series(
          name="Empleador",
          data = ITLP_mother_base4$SM_TLPpos_ocu2, tittle=list(text="Empleador"),
          color = "#54a9b3"
        ) %>%
        hc_add_series(
          name="Cuenta Propia",
          data = ITLP_mother_base4$SM_TLPpos_ocu3, tittle=list(text="Cuenta Propia"),
          color = "#da7b3e"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    if(input$radio4==2){
      h5<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por Posición</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base4$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="Subordinado Remunerado",
          data = ITLP_mother_base4$MM_TLPpos_ocu1, tittle=list(text="Subordinado Remunerado"),
          color = "#8be137"
        ) %>%
        hc_add_series(
          name="Empleador",
          data = ITLP_mother_base4$MM_TLPpos_ocu2, tittle=list(text="Empleador"),
          color = "#54a9b3"
        ) %>%
        hc_add_series(
          name="Cuenta Propia",
          data = ITLP_mother_base4$MM_TLPpos_ocu3, tittle=list(text="Cuenta Propia"),
          color = "#da7b3e"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    h5
  })
  
  ##################################################ITLP seg####################################################
  
  output$seg <- renderHighchart({
    ITLP_mother_base5<-ITLP_mother_base%>%
      filter(year>=input$slider5[1] & year<=input$slider5[2])
    if(input$radio5==0){
      h5<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por acceso a seguridad social</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base5$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="Con Acceso",
          data = ITLP_mother_base5$HT_TLPseg_soc1, tittle=list(text="Con Acceso"),
          color = "#3c7480"
        ) %>%
        hc_add_series(
          name="Sin Acesso",
          data = ITLP_mother_base5$HT_TLPseg_soc2, tittle=list(text="Sin Acesso"),
          color = "#f4554f"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    if(input$radio5==1){
      h5<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por acceso a seguridad social</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base5$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="Con Acceso",
          data = ITLP_mother_base5$SM_TLPseg_soc1, tittle=list(text="Con Acceso"),
          color = "#3c7480"
        ) %>%
        hc_add_series(
          name="Sin Acesso",
          data = ITLP_mother_base5$SM_TLPseg_soc2, tittle=list(text="Sin Acesso"),
          color = "#f4554f"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    
    if(input$radio5==2){
      h5<-highchart()%>%
        hc_title(
          text = "<b>Pobreza laboral por acceso a seguridad social</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_xAxis(
          categories = ITLP_mother_base5$fecha, title=list(text="Trimestre"),
          title = list(style = list(color = "FFFFFF")),
          labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_yAxis_multiples(
          list(title=list(text="ITLP"),
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF")))
        ) %>%
        hc_add_series(
          name="Con Acceso",
          data = ITLP_mother_base5$MM_TLPseg_soc1, tittle=list(text="Con Acceso"),
          color = "#3c7480"
        ) %>%
        hc_add_series(
          name="Sin Acesso",
          data = ITLP_mother_base5$MM_TLPseg_soc2, tittle=list(text="Sin Acesso"),
          color = "#f4554f"
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    h5
  })
  
  ##################################################ITLP trans####################################################
  
  output$transfer <- renderHighchart({
    
    if(input$radio_t==0){
     transferencias<- highchart() %>% 
        hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                   labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_chart(type ="column") %>%
        hc_xAxis(categories = aprobado$Alcaldia,
                 title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))) %>% 
        hc_add_series(data = aprobado$Monto_2018, name = "Aprobado",
                      color = "#749ca4"
        )%>%
        hc_add_series(data = ejercido$Monto_2018, name = "Ejercido",
                      color = "#c84e41"     
        )%>%
        hc_title(
          text = "<b>Transferencias a alcaldías para desarrollo social</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    if(input$radio_t==1){
      transferencias<-highchart() %>% 
        hc_chart(type ="column") %>%
        hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                   labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_xAxis(categories = aprobado$Alcaldia,
                 title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))) %>% 
        hc_add_series(data = aprobado$Monto_2019, name = "Aprobado",
                      color = "#749ca4"
                      )%>%
        hc_add_series(data = ejercido$Monto_2019, name = "Ejercido",
                      color = "#c84e41"
                      ) %>%
        hc_title(
          text = "<b>Transferencias a alcaldías para desarrollo social</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    if(input$radio_t==2){
      transferencias<-highchart() %>% 
        hc_chart(type ="column") %>%
        hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                   labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_xAxis(categories = aprobado$Alcaldia,
                 title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))) %>% 
        hc_add_series(data = aprobado$Monto_2020, name = "Aprobado",
                      color = "#749ca4"
                      )%>%
        hc_add_series(data = ejercido$Monto_2020, name = "Ejercido",
                      color = "#c84e41"
                      ) %>%
        hc_title(
          text = "<b>Transferencias a alcaldías para desarrollo social</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    transferencias
  })
  
  ##################################################spend des####################################################
  
  output$gdes <- renderHighchart({
    if(input$radio_des==0){
      hd<- highchart() %>% 
        hc_chart(type ="column") %>%
        hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                   labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_xAxis(categories = desempleo_aprobado$Unidad,
                 title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))) %>% 
        hc_add_series(data = desempleo_aprobado$Monto_2018, name = "Aprobado",
                      color = "#749ca4"
                      )%>%
        hc_add_series(data = desempleo_ejercido$Monto_2018, name = "Ejercido",
                      color = "#c84e41" 
                      ) %>%
        hc_title(
          text = "<b>Egresos de la CDMX, Sub-función: Desempleo</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    if(input$radio_des==1){
      hd<- highchart() %>% 
        hc_chart(type ="column") %>%
        hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                   labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_xAxis(categories = desempleo_aprobado$Unidad,
                 title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))) %>% 
        hc_add_series(data = desempleo_aprobado$Monto_2019, name = "Aprobado", color = "#749ca4")%>%
        hc_add_series(data = desempleo_ejercido$Monto_2019, name = "Ejercido", color = "#c84e41") %>%
        hc_title(
          text = "<b>Egresos de la CDMX, Sub-función: Desempleo</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    if(input$radio_des==2){
      hd<- highchart() %>% 
        hc_chart(type ="column") %>%
        hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                   labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_xAxis(categories = desempleo_aprobado$Unidad,
                 title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))) %>% 
        hc_add_series(data = desempleo_aprobado$Monto_2020, name = "Aprobado", color = "#749ca4")%>%
        hc_add_series(data = desempleo_ejercido$Monto_2020, name = "Ejercido", color = "#c84e41") %>%
        hc_title(
          text = "<b>Egresos de la CDMX, Sub-función: Desempleo</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    if(input$radio_des==3){
      hd<- highchart() %>% 
        hc_chart(type ="column") %>%
        hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                   labels = list(style = list(color = "FFFFFF"))
        ) %>%
        hc_xAxis(categories = desempleo_aprobado$Unidad,
                 title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))) %>% 
        hc_add_series(data = desempleo_aprobado$Monto_2021, name = "Aprobado", color = "#749ca4")%>%
        hc_add_series(data = desempleo_ejercido$Monto_2021, name = "Ejercido", color = "#c84e41") %>%
        hc_title(
          text = "<b>Egresos de la CDMX, Sub-función: Desempleo</b>",
          style = list(color = "#FFFFFF", useHTML = TRUE)
        ) %>%
        hc_exporting(
          enabled=TRUE
        )%>%
        hc_add_theme(
          hc_theme_db()
        )
    }
    hd
  })
  
  
  output$gdes2 <- renderHighchart({
    highchart() %>% 
      hc_chart(type ="column") %>%
      hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))
      ) %>%
      hc_xAxis(categories = alcaldias_desmpleo$Unidad,
               title = list(style = list(color = "FFFFFF")),
               labels = list(style = list(color = "FFFFFF"))) %>% 
      hc_add_series(data = alcaldias_desmpleo$Aprobado, name = "Aprobado", color = "#749ca4")%>%
      hc_add_series(data = alcaldias_desmpleo$Ejercido, name = "Ejercido", color = "#c84e41") %>%
      hc_title(
        text = "<b>Egresos de la CDMX para Desempleo por Alcaldía</b>",
        style = list(color = "#FFFFFF", useHTML = TRUE)
      ) %>%
      hc_exporting(
        enabled=TRUE
      )%>%
      hc_add_theme(
        hc_theme_db()
      )
  })
  
  
  ##################################################ss####################################################
  cols <- carto_pal(10, "Prism")
  output$ss1 <- renderHighchart({
    programas_cdmx %>%
      hchart(type = 'bar', hcaes(x = Programa, y = Poblacion, group = type)) %>%
      hc_xAxis(
        title = list(style = list(color = "FFFFFF")),
        labels = list(style = list(color = "FFFFFF"))
      )%>%
      hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))
      ) %>%
      hc_colors(cols)%>%
      hc_title(
        text = "<b>Alcances de programas sociales</b>",
        style = list(color = "#FFFFFF", useHTML = TRUE)
      ) %>%
      hc_exporting(
        enabled=TRUE
      )%>%
      hc_add_theme(
        hc_theme_db()
      )
  })
  
  output$ss2 <- renderHighchart({
    Programas_cdmx_presupuesto %>%
      hchart(
        "pie", hcaes(x=Programa, y=presupuesto)
      )%>%
      hc_colors(cols)%>%
      hc_title(
        text = "<b>Presupuesto por programa</b>",
        style = list(color = "#FFFFFF", useHTML = TRUE)
      ) %>%
      hc_exporting(
        enabled=TRUE
      )%>%
      hc_add_theme(
        hc_theme_db()
      )
  })
  
  output$ss3 <- renderHighchart({
    nbi%>%
      hchart(type = 'column', hcaes(x = Estrato, y = count, group = gen))%>%
      hc_xAxis(
        title = list(style = list(color = "FFFFFF")),
        labels = list(style = list(color = "FFFFFF"))
      )%>%
      hc_yAxis(  title = list(style = list(color = "FFFFFF")),
                 labels = list(style = list(color = "FFFFFF"))
      ) %>%
      hc_colors(cols)%>%
      hc_title(
        text = "<b>Población por estratos socioeconómicos NBI</b>",
        style = list(color = "#FFFFFF", useHTML = TRUE)
      ) %>%
      hc_exporting(
        enabled=TRUE
      )%>%
      hc_add_theme(
        hc_theme_db()
      )
  })
  
  ##################################################MAPA####################################################
  
  output$maps <- renderLeaflet({
  
  shape40 <- merge(x = shape_mun, y = sol_ciudad, by = c("CVE_MUN","CVE_ENT"))
  
  
  shape2 <- shape40 
  
  
  popup <- paste0(
    "<b>","Nombre estado: ",   "</b>",   as.character(shape2$NOM_MUN) ,        "<br>",                     
    "<b>", "# de Solicitudes aprobadas"  ,   "</b>",   shape2$approved              , 
    "<b>", "# de Solicitudes negadas"  ,   "</b>",   shape2$not_approved              , "<br>" )
  
  palnumeric <- colorNumeric("viridis", domain = shape2$approved)
  
  palnumeric2<- colorNumeric("magma", domain = shape2$not_approved)
  mytext <- paste(
    "Alcaldia: ",shape2$NOM_MUN,"<br/>", 
    "# de Solicitudes aprobadas: ", round(shape2$approved,2), "<br/>",
    "# de Solicitudes negadas: ", round(shape2$not_approved,2), "<br/>",
    # "Year: ", shape2$Year, "<br/>",
    sep="") %>%
    lapply(htmltools::HTML)
  
  
  m1<- leaflet(shape2,options = leafletOptions(
    zoomControl = TRUE, minZoom = 2, maxZoom = 20, attributionControl = FALSE)) %>%
    # Opcion para anadir imagenes o mapas de fondo (tiles)
    addProviderTiles("CartoDB.Positron") %>% #"Esri.WorldTerrain" "CartoDB.DarkMatter"
    # Funcion para agregar poligonos
    addPolygons(color = "white" ,
                weight = .001, #linea de division 0.2 el valor perfecto
                smoothFactor = 0.3, #suavizado entre mapas 0.3 el valor perfecto
                opacity = 2, # color de la linea
                fillOpacity = .9,
                fillColor = ~palnumeric(shape2$approved),# Color de llenado
                group = "Numero de Solicitudes Aprobadas",
                layerId = ~shape2$CVE_EDO,                  
                highlightOptions = highlightOptions(color = "#efb810", weight = ,
                                                    bringToFront = TRUE), #highlight cuando pasas el cursor
                label = mytext ,                                  # etiqueta cuando pasas el cursor
                labelOptions = labelOptions(direction = "auto",style = list("font-weight" = "normal", padding = "3px 8px"), 
                                            textsize = "13px",),
                popup = popup)  %>%  
    addLegend(pal = palnumeric,values = ~shape2$approved, title = "Numero de Solicitudes Aprobadas",position = "topright",opacity=.9) %>% 
    addPolygons(color = "white" ,
                weight = .001, #linea de division 0.2 el valor perfecto
                smoothFactor = 0.3, #suavizado entre mapas 0.3 el valor perfecto
                opacity = 2, # color de la linea
                fillOpacity = .9,
                fillColor = ~palnumeric2(shape2$not_approved),
                group = "Numero de Solicitudes Negadas",
                layerId = ~shape2$CVE_EDO,                  
                highlightOptions = highlightOptions(color = "#efb810", weight = ,
                                                    bringToFront = TRUE), #highlight cuando pasas el cursor
                label = mytext ,                                  # etiqueta cuando pasas el cursor
                labelOptions = labelOptions(direction = "auto",style = list("font-weight" = "normal", padding = "3px 8px"), 
                                            textsize = "13px",),
                popup = popup)  %>%  
    addLegend(pal = palnumeric2,values = ~shape2$not_approved, title = "Numero de Solicitudes Negadas",position = "bottomleft",opacity=.9) %>%
    addLayersControl( 
      baseGroups = c("Numero de Solicitudes Aprobadas", "Numero de Solicitudes Negadas"))
  
  m1
  
  })
  
  
}





shinyApp(ui, server)