library(shiny)

# Define UI 
shinyUI(fluidPage(

  # Application title
  headerPanel("Gold Coast BUGS algorithm assessment"),

  sidebarPanel(
  	h3("Instructions:"),
  	helpText("Use the slider below to select a portion of parcels by area.  For example, selcting 10 will show you the top 10% parcels by area"),
  	 sliderInput("quantile", "Top percentage by Area:", 
                min=0, max=10, value=10),
      helpText(
      	"Once you have found a parcel you are interested in viewing you can enter the parcelID below to retrieve a satellite image centered on the estimated building centroid, visible in the satellite chip tab"
      ),
      numericInput(
      	"lon", 
      	"Parcel lon to retrieve satellite chip:", 
      	153.42
      	),
      	
      numericInput(
      	"lat", 
      	"Parcel lat to retrieve satellite chip:", 
      	-28.017
      	),	
	submitButton("Update")
	

  ),

  mainPanel(
   tabsetPanel(
      tabPanel("Introduction",
      	h1("Introduction:"),
      	 p("This app is built using RShiny to determine the accuracy of DigitalGlobe's HUGS algorithm for classifying building centroids in land parcels in Australia"),
      	 p("Here's an explanation of whats going on"),
      	 h3("Satellite Chip Tab:"),
      	 p("There are quite a few chips corresponding to the top 10% of
      	 	parcel areas.  In order to avoid downloading each and every
      	 	image the satellite chip tab contains a call to the ChipAPI
      	 	provided by Digital Globe, based on the ID of the parcel.  The ID
      	 	is entered on the sidebar to the left and the image is retrieved.
      	 	The speed of this is limited by the response time for the ChipAPI 
      	 	retrieval.")
      	 
      	 ), 
      tabPanel("Data in Table Form",
      	dataTableOutput("location.table")
      	),
      	 
      tabPanel("Maps", 
      	plotOutput("map", width="800px",height="800px")
      	),
      
      tabPanel("Satellite Chips",
   		uiOutput("chipURL")
      	)
    )

  
  )
))
