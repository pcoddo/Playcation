library(shiny)
library(shinyWidgets)
library(globe4r)
library(bslib)
library(formattable)


# Custom theme
my_theme = bs_theme(
  bg = "#000014", 
  fg = "#FDF7F7", 
  primary = "#ff5964", 
  base_font = font_google("Lato"),
  heading_font = font_google("Boogaloo"),
  code_font = font_google("JetBrains Mono"),
  font_scale = 1.15,
  link_hover_color = "#FDF7F7"
)



shinyUI <- 

  bootstrapPage(
    list(tags$head(tags$link(rel="shortcut icon", href="icon.jpg"),
                      tags$style(type = "text/css", ".navbar-brand{display:none;} .navbar{margin-bottom:}"))),
    
    # Fluid container 
    div(class = "container-fluid",
      
      # Begin navbar design  
      page_navbar(
        title = "Playcation",
        id = "nav",
        theme = my_theme,
        inverse = FALSE,
        bg = "#000011",
        nav_spacer(),
  
        ### App Panel ###
        tabPanel("The App",
                 
          # Glob Insert
          fluidRow(
            
            column(7, align="center",
                   div(class="outer",
                       globeOutput("globe", width="100%", height="100%"),
                       
                       absolutePanel(
                         top = -50, left = 10, width=350, 
                         style = "z-index:500;",
                         htmlOutput("title", style="scrolling: no"),
                       ),
                       
                       absolutePanel(
                         h2("First, pick your destination"),
                         top = 550, left = 50, style = "z-index:500;", 
                         div(
                           actionBttn(
                             inputId = "zoom",
                             label = "Shuffle",
                             style = "material-flat",
                             color = "danger")
                         )
                       ),
                   )
            ),
          
          # Tabset Insert
            column(5, 
                   #textOutput("destination"),
                   h2("Next, customize your trip"),
                   
                   tabsetPanel(
                     id="tabs", type = "pills", 
                     
                     # Wiki
                     tabPanel(
                       title="Research",
                       column(
                         12,
                         htmlOutput("wiki")
                       )
                     ),
                     
                     # Budget
                     tabPanel(
                       tags$head(includeCSS("mystyle.css")),
                       title="Budget",
                       column(
                         12,
                         htmlOutput("budget"),
                         h5(textOutput("tabtitle"), align="center"),
                         formattableOutput("table")
                       )
                     ),
                     
                     # Occassion
                     tabPanel(
                       title="Occassion",
                       column(
                         12,
                         htmlOutput("occassion")
                       )
                     ),
                     
                     # Surprise
                     tabPanel(
                       title="Surprise",
                       column(
                         12,
                         htmlOutput("surprise")
                       )
                     ),
                   )
            )
          
          ) # /fluidRow
          
        ), # /tabPanel
        
        ### About Section ###
        tabPanel("About", 
                 fluidPage(
                 h2("About the Podcast(s)"),
                 fluidRow(
                   column(8, 
                          h3(tags$a("Playcation", href="https://twitter.com/TheBigOnesPod", target="_blank")),
                          HTML("<p>
                          The new Summer Series from THE BIG ONES is here! PLAYCATION! <a href='https://twitter.com/Amandafunbuns' target='_blank'>Amanda Lund</a> and 
                          <a href='https://twitter.com/m_blasucci' target='_blank'>Maria Blasucci</a> have been cooped up in the house for too long and they're ready to travel the world. Well, almost ready. 
                          On Playcation, Amanda and Maria plan rival vacations to the same far-off (or near) land and listeners vote on whose trip 
                          they'd rather take. The WHEEL OF ADVENTURE determines their budgets, reason for travel and one travel hiccup. From Bermuda 
                          to Australia to Berlin, Maria and Amanda travel the world from the comfort of their own homes and take their listeners 
                          along for the ride. New episodes debut Tuesday wherever you get your pods!</p>")),
                   column(4,
                          img(src="icon.jpg", width="300px", style = "display: block; margin-left: auto; margin-right: auto; margin-top: 20px;"))
                   ),
                   
                   fluidRow(
                     column(8,
                            h3(tags$a("The Big Ones", href="https://www.earios.net/the-big-ones", target="_blank")),
                            HTML("<p>
                            Fine tune your morality muscle with Earios founders, Maria Blasucci and Amanda Lund, 
                            as they discuss life's BIG ONES. Each week will be a new ethical question ranging from 
                            historical decisions to relationship dilemmas to brain-busting moral choices. 
                            The questions can be complicated, but they're always fun to discuss because they 
                            force you to look deep, deep, deep withinside&trade; yourself. Will you like what you see?</p>")),
                     column(4,
                            img(src="bigones.jpg", width="300px", style = "display: block; margin-left: auto; margin-right: auto; margin-top: 50px;"))
                     ),
                 
                 h2("About the App"),
                 fluidRow(
                      column(12,
                          HTML("<p>
                          This application attempts to replicate the Playcation podcast experience with a few small modifications. Playcation
                          destinations are randomly sampled from Wikipedia's list of the<a href='https://en.wikipedia.org/wiki/List_of_cities_by_international_visitors' target='_blank'>
                          top 100 cities of cities by international visitors</a> (Mastercard rankings). Lodging budgets are determined 
                          using the U.S. Department of State's <a href='https://aoprals.state.gov/web920/per_diem_action.asp?MenuHide=1&CountryCode=0000' target='_blank'>
                          Foreign per diem rates</a>, setting each city's lodging rate the value for the <b>Economy</b> tier. Additional
                          budget tiers are determined using this baseline rate:</p>
                          <br>"),
                      )
                 ),
                 
                 fluidRow(
                        column(4,
                          HTML(
                          "<table style='width:100%; border-collapse: collapse; line-height:1.15; font-size: 1.15rem;'>
                            <tr>
                              <th style='border-bottom: 1px solid #FDF7F7; color: #ff5964'>Tier</th>
                              <th style='border-bottom: 1px solid #FDF7F7; color: #ff5964'>Budget ($)</th>
                            </tr>
                            <tr>
                              <td>Roughing It</td>
                              <td>Baseline / 5</td>
                            </tr>
                            <tr>
                              <td>Economy</td>
                              <td>Baseline</td>
                            </tr>
                            <tr>
                              <td>Extreme Comfort</td>
                              <td>Baseline x 3</td>
                            </tr>
                            <tr>
                              <td>Luxury</td>
                              <td>Baseline x 5</td>
                            </tr>
                            <tr>
                              <td>Clooney</td>
                              <td>2000+</td>
                            </tr>
                          </table>
                          <br>")
                          ),
                        
                        column(8,
                            HTML("
                          There are 6 possible travel Occassions and 8 possible Surprise scenarios&#8212keep playing until you get them all!
                          <br>
                          ")
                        
                 
                      )
                    
  
                 ),
                 
                 # Logo
                 absolutePanel(tags$head(includeCSS("mystyle.css")),
                               id = "logo", class = "card", bottom = 20, right = 20, width = 40, height = "auto", fixed=TRUE, draggable = FALSE, 
                               actionButton("github_share", label = "", icon = icon("github"),style='padding:5px',
                                            onclick = sprintf("window.open('%s')", 
                                                              "https://github.com/pcoddo")))
                 ) 
                 ), #/tabPanel
        
        # Play music             
        nav_item(
          actionButton("playmusic", label = "", icon=icon("music"),
                       style="background-color: #000011; border-color: #000011")),
      ) #/ fluidcontainer
      
    ) # /navbarPage
  ) 