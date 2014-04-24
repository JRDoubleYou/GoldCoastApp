library(shiny)
library(ggmap)


load("./data/locations.Rdata")




shinyServer(function(input, output) {
	
	
	threshold <-reactive({
	quantile(parcel.areas.UTM,
		1-(.01*input$quantile))

	})

	location.subset <-reactive({
	subset(locations,locations$Parcel_Area > threshold()) 
	})
	 
	shp.file.idx<-reactive({
		!is.na(match(parcel.IDs,location.subset()[,"ParcelID"]))
		})
	
	shp.file <-reactive({
		fortify(parcel[shp.file.idx(),])
		})
	
	loc <- reactive({
		bbox
	})	
	
	output$location.table <- renderDataTable({
		location.subset()
		})
	
	
	output$map <-renderPlot({
		print(
			ggmap(get_map(c(lon=153.4,lat=-28.1),zoom=13)) +
			geom_polygon(aes(x=long, y=lat, group=group), fill='grey', 	size=.5,color='black', data=shp.file(), alpha=0)
			)
	})
	
	output$chipURL <- renderUI({   
        HTML(paste("'<img src=\"http://dev1.tomnod.com/chip_api/chip/lat/",input$lat,"/lng/",input$lon,"\">'",sep=""))
      }) 


})	
