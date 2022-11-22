fluidPage(
  # Navbar allows for the ui to slit into multiple different pages with different layout parameters
  navbarPage(
    
    # Navbar project name that appears in the top left corner
    "Project",
    
    # First Tab Panel that servers as a landing page to describe the basics of the data before
    # Anything else is said about the data and model ----
    tabPanel("About",
             sidebarLayout(
               sidebarPanel(p("This is the about page to learn about the model!")),
               mainPanel(p("For all the models here are the reference categories:
                           Road Class = County Road,
                           Time of Day = Morning,
                           Weather = Normal,
                           Collision Type = One Car,
                           At Intersection = False"))
             )
    ),
    
    # Page dedicated to the Descriptive statistics of the model ----
    tabPanel("Desc",
             
             # Sidebar-mainpanel layout for Descriptive Statistics
             sidebarLayout(
               
               #Input Parameters for Descriptive Statistics
               sidebarPanel(
                 
                 # Input: Radio Buttons for variable selection
                 radioButtons("DescRadio",
                              label = "Select Varaible:",
                              choices = colnames(crash),
                              selected = "Crash.Severity")
                 
               ),
               mainPanel(
                 
                 # Output: Dynamic plot for Viewing Data
                 plotOutput("DescPlot")
                 
               )
            )
    ),
    
    # Page dedicated to the Inferential statistics of the model ----
    tabPanel("Inf",
             
             # Sidebar-mainpanel layout for Descriptive Statistics
             sidebarLayout(
               
               # Input Parameters for Inferential Statistics
               sidebarPanel(
                 
                # Input: Check boxes for Models to Display
                checkboxGroupInput("InfCheck",
                                    label = "Select Models:",
                                    choices = c("Stage 1", "Stage 2", "Stage 3", "Stage 4"),
                                    selected = c("Stage 1", "Stage 2", "Stage 3", "Stage 4")
                 ),
                 
                # Input: Radio Buttons for Intersection Flag
                radioButtons("InfInterInput",
                              label = "At Intersection:",
                              choices = c("True", "False"),
                              selected = "False"
                ),
                
                # Input: Radio Buttons for Time of Day
                radioButtons("InfTimeInput",
                             label = "Select Time of Day:",
                             choices = c("Morning", "Day", "Evening", "Night"),
                             selected = "Morning"
                ),
          
                # Input: Slider for Speed limit
                sliderInput("InfSpeedInput",
                             label = "Select Speed:",
                             min = 5,
                             max = 85,
                             step = 5,
                             value = 45
                ),
                
                # Input: Radio Buttons for Weather
                radioButtons("InfWeathInput",
                             label = "Select Weather",
                             choices = c("Normal Weather", "Dangerous Weather"),
                             selected = "Normal Weather"
                ),
                
                # Input: Radio Buttons for Type of Collision
                radioButtons("InfCollInput",
                             label = "Select Type of Collision",
                             choices = c("One Car", "Same Direction", "Angular", "Opposite Direction", "Other"),
                             selected = "Opposite Direction"
                )
                  
                 
               ),
               mainPanel(
                 
                 #Output: Plot for viewing results
                 tableOutput("InfProbPlot")
               )
            )
    ),
    
    # Page dedicated to anything else ----
    tabPanel("Other",
             sidebarLayout(
               sidebarPanel(p("text")),
               mainPanel(p("main"))
            )
    )
  )
)