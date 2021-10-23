#Code to create ScotPHO's Shiny profile platform
# This script includes the user-interface definition of the app.



###############################################.
## Header ---- 
###############################################.
dashboardPage(title = "Datatón", skin= "purple",
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
