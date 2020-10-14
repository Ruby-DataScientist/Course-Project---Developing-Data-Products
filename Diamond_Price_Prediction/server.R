library(shiny)
library(ggplot2)
library(dplyr)
library(rsconnect)

# Select columns to be used in the analysis
diam <- diamonds[,c(1:5,7)]

# Define server logic required to draw a plot
shinyServer(function(input, output) {
    output$distPlot <- renderPlot({
        # Select diamonds depending of user input
        diam <- filter(diamonds, grepl(input$cut, cut), grepl(input$col, color), grepl(input$clar, clarity), grepl(input$depth, depth))
        # build linear regression model
        # fit <- step(lm( price~carat+cut+color+depth, diam)
        fit = lm(data = diam, price~carat)
        # predicts the price
        pred <- predict(fit, newdata = data.frame(carat = input$car,
                                                  cut = input$cut,
                                                  color = input$col,
                                                  clarity = input$clar,
                                                  depth=input$depth))
        # Draw the plot using ggplot2
        plot <- ggplot(data=diam, aes(x=carat, y = price))+
            geom_point(aes(color = cut), alpha = 0.5)+
            geom_smooth(method = "lm")+
            geom_vline(xintercept = input$car, color = "blue")+
            geom_hline(yintercept = pred, color = "green")
        plot
    })
    output$result <- renderText({
        # Renders the text for the prediction below the graph
        diam <- filter(diamonds, grepl(input$cut, cut), grepl(input$col, color), grepl(input$clar, clarity),grepl(input$depth, depth))
        fit = lm(data = diam,price~carat)
        pred <- predict(fit, newdata = data.frame(carat = input$car,
                                                  cut = input$cut,
                                                  color = input$col,
                                                  clarity = input$clar,
                                                  depth=input$depth))
        res <- paste(round(pred, digits = 1.5),"$" )
        res
    })
    
})

