function(input, output){
  # Input parameters ----
  
  # Input for INF page PROB
  
    # Select which Models to Display
    InfProbModel <- reactive({
      as.numeric(gsub("Stage ", "", input$InfCheck))
    })
    
    # Input Parameter Transformations
    InfProbInter <- reactive({
      switch(input$InfInterInput,
             "True" = 1,
             "False" = 0)
    })
    
    InfProbTime <- reactive({
      switch(input$InfTimeInput,
             "Morning" = c(0,0,0),
             "Day" = c(1,0,0),
             "Evening" = c(0,1,0),
             "Night" = c(0,0,1))
    })
    
    InfProbWeath <- reactive({
      switch(input$InfWeathInput,
             "Normal Weather" = 0,
             "Dangerous Weather" = 1)
    }) 
    
    InfProbColl <- reactive({
      switch(input$InfCollInput,
             "One Car" = c(0,0,0,0),
             "Angular" = c(1,0,0,0),
             "Opposite Direction" = c(0,1,0,0),
             "Other" = c(0,0,1,0),
             "Same Direction" = c(0,0,0,1))
    })
  
  
  # Output functions ----
  # Desc Page, Descriptive Plot
  output$DescPlot <- renderPlot({
    plot <- plot(x = 1:10, y = 1:10,
                 main = input$DescRadio)
    
  })
  
  # Inf Page Probability Plot
  output$InfProbPlot <- renderTable({
    # Create a vector of parameters for probability
    probparameter <- c(input$InfSpeedInput,InfProbWeath(),InfProbTime(),InfProbColl(),InfProbInter())
    
    # Create the coefficient matrix to get the log odds
    estmat <- matrix(0, nrow = length(InfProbModel()), ncol = 18)
    for (i in InfProbModel()){
      i2 <- match(i, InfProbModel())
      estmat[i2,] <- as.numeric(coeff.matrix$Estimate[c(seq(i,32,4),33:42)])
    }
    
    # Create the parameter matrix to get the log odds
    parmat <- matrix(0, nrow = 18, ncol = 8)
    for (i in 1:8){
      parmat[,i] <-  c(1,rep(0,max(0,i-2)),ifelse(i == 1,0,1),rep(0,min(6,8-i)),probparameter)
    }
    
    # Create a matrix that is the predicted log odds
    # Rows are models, columns are Road classes
    probest <- as.data.frame(estmat %*% parmat)
    
    # Transforms log odds into probability using e^y / (e^y + 1) where y is the predicted log odds
    probest <- exp(probest) / (exp(probest) + 1)
    
    # After conversion into data frame, label columns
    colnames(probest) <- c("County Road", "City Street", "Farm to Market", "Interstate", "Non-Trafficway", "Other Road", "Tollways", "US & State Highways")

    
    return(probest)
  })
  
}