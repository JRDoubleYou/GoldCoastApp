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
      	 h3("Data in Table Form Tab:"),
      	 p("This tab shows information for a given percentage of the largest parcels in the Gold Coast City shapefile that was provided.  To select what percentage you would like to see use the slider tab to the left and click the Update button.  The table allows you to sort the entries by any of the fields of interest"),
      	 h3("Maps Tab:"),
      	 p("The maps tab will show the polygon boundaries for the land parcels that are selected using the slider.  This requires a call to the google maps API and can take a moment to load."),
      	 
      	 h3("Satellite Chip Tab:"),
      	
      	 p("There nearly 3000 chips corresponding to the top 10% of
      	 	parcel areas.  In order to avoid downloading each and every
      	 	image the satellite chip tab contains a call to the ChipAPI
      	 	provided by Digital Globe.  The latitude and longitude of a parcel of interest is read from the data table tab and 
      	entered on the sidebar to the left. The image is then retrieved through the API.
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
