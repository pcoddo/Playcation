library(globe4r)
library(dplyr)
library(shiny)
library(formattable)

# Read in cities
df=read.csv("data/cities.csv")

# Starting parameters
start=df[1,]
start$country_code="FRN"


### SHINY SERVER ###
server <- function(input, output, session){
  output$globe <- 
    render_globe({
      create_globe(height = "65vh") %>% 
        globe_pov(lat=0, lon=0, altitude=3.5) %>%
        
        globe_choropleth(
          coords(country = country_code, 
                 altitude = 0.05,
                 cap_color = "blue"), data = start) %>% 
        polygons_cap_color(constant("rgba(255, 0, 0, 0.5)")) %>%
        polygons_side_color(constant("rgba(255, 0, 0, 0.75)")) %>% 
        
        globe_background("#000014") %>%
        globe_img_url(image_url("blue")) %>%
        globe_rotate(speed=0.02L) 
    })
  
  # Budget table
  output$table <- renderFormattable({
    Cat_init = c("Roughing It", "Economy", "Extreme Comfort", "Luxury", "Clooney")
    Cost_init = rep("---", length(Cat_init))
    
    tmp = as.data.frame(Cost_init, Cat_init)
    colnames(tmp) = "Budget ($)"
    tmp = formattable(tmp)
  })
  
  
  
  observeEvent(input$zoom, {
    
    # Find Playcation destination
    dest=sample_n(df,1)
    
    # Render Message
    output$selection <- renderText({ 
      paste("You're going to: ", dest$Label, sep="")
      #paste("You're going to: ", dest$City, ", ", dest$country, sep="")
      
    })
    
    # Find Lodging budget
    Category = c("Roughing It", "Economy", "Extreme Comfort", "Luxury", "Clooney")
    Cost = floor(c(dest$Lodging/5, dest$Lodging, dest$Lodging*3, dest$Lodging*5, 2000))
    
    Lodging = mat.or.vec(nr=5, nc=1)
    Lodging[1] = paste("<", Cost[1])
    Lodging[2] = paste(Cost[1], "-", Cost[2], sep="")
    Lodging[3] = paste(Cost[2]+1, "-", Cost[3], sep="")
    Lodging[4] = paste(Cost[3]+1, "-", "1,999", sep="")
    Lodging[5] = "2,000+"
    
    budget_table =  data.frame(Lodging)
    rownames(budget_table) = Category
    colnames(budget_table) = "Budget ($)"
    budget_table = formattable(budget_table)
    #budget_table = t(budget_table)
    
    # Render table
    output$table <- renderFormattable({ 
      
      budget_table
      
    })
    
    # Render table title
    output$tabtitle <- renderText({ 
      paste("Lodging budget for ", dest$Label, sep="")
    })
    
    
    # Add destination to globe
    globeProxy("globe") %>% 
      
      globe_pov(lat=dest$Latitude, lon=dest$Longtitude, altitude=2.25) %>%
      
      globe_choropleth(
        coords(country=country_code, altitude=0.04),
        data=dest) %>%
      
      globe_labels(
        coords(
          lat=Latitude, lon=Longtitude, text=Label, 
          size=3, altitude=0.051, dot_radius=0.5
        ), data=dest
      )
    
    
    # Render wiki iframe
    output$wiki <- renderUI({
      tags$iframe(seamless="seamless", 
                  style = "margin-top: 15px; margin-bottom: 15px; height: min(500, 700);",
                  src= dest$Link,
                  width="100%", height="700",
                  allowtrasparence="true", frameBorder="0")
    })
    
    # Render destination message
    output$destination <- renderText(
      paste("Congratulations, you're going to ", dest$Label, sep="")
    )
    
    #updateTabsetPanel(session, "tabs", "Research")

  })
  
  
  observeEvent(input$playmusic, {
    insertUI(selector = "#playmusic",
             where = "afterEnd",
             ui = tags$audio(src = "song.mp3", type = "audio/mp3", autoplay = T, controls = NA, style="display:none;")
    )
  })
  
  

  
  output$budget <- renderUI({
    tags$iframe(seamless="seamless", 
                src= "budget.html",
                width="100%", #height="500",
                style="height:clamp(275px, 80vmin, 525px)",
                id="budgetframe",
                allowtrasparence="true", frameBorder="0")
  })
  
  output$occassion <- renderUI({
    tags$iframe(class="responsive-iframe",
                style="-webkit-transform:scale(0.85);-moz-transform-scale(0.85);",
                scrolling="no",
                seamless="seamless", 
                src= "occassion.html",
                width="100%", height="650",
                id="occassionframe",
                allowtrasparence="true", frameBorder="0")
  })
  output$surprise <- renderUI({
    tags$iframe(seamless="seamless", 
                src= "surprise.html",
                width="100%", height="500",
                id="surpriseframe",
                allowtrasparence="true", frameBorder="0")
  })
  
  output$title <- renderUI({
    tags$iframe(seamless="seamless", 
                src= "title.html",
                scrolling = "no",
                overflow = "hidden",
                width="100%", height="115",
                id="titleframe",
                allowtrasparence="true", frameBorder="0")
  })
  
  
}