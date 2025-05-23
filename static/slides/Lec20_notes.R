library(tidyverse)
library(shiny)
library(bslib)


ui = page_sidebar(
  title = "Beta-Binomial",
  theme = bs_theme(),
  sidebar = sidebar(
    h4("Data:"),
    sliderInput("x", "# of heads", min=0, max=100, value=7),
    sliderInput("n", "# of flips", min=0, max=100, value=10),
    h4("Prior:"),
    numericInput("alpha", "Prior # of head", min=0, value=5),
    numericInput("beta", "Prior # of tails", min=0, value=5),
  ),
  
  bslib::navset_card_tab(
    bslib::nav_panel(
      title = "Plot",
      card(
        card_header(
          "Output",
          popover(
            fontawesome::fa("gear", a11y = "sem", title = "Settings"),
            title = "Settings",
            checkboxInput("bw", "Use theme_bw", value = FALSE),
            checkboxInput("facet", "Use facets", value = FALSE)
          )
        ),
        card_body(
          plotOutput("plot")
        ),
        full_screen = TRUE
      )
    ),
    bslib::nav_panel(
      title = "Table",
      card(
        tableOutput("table")
      )
    )  
  )
  

)
server = function(input, output, session) {
  bs_themer()
  
  observe({
    updateSliderInput(session, "x", max = input$n)
  })

  d = reactive({
    tibble(
      p = seq(0, 1, length.out = 1000)
    ) %>%
      mutate(
        prior = dbeta(p, input$alpha, input$beta),
        likelihood = dbinom(input$x, size = input$n, prob = p) %>% 
          {. / (sum(.) / n())},
        posterior = dbeta(p, input$alpha + input$x, input$beta + input$n - input$x)
      ) %>%
      pivot_longer(
        cols = -p,
        names_to = "distribution",
        values_to = "density"
      ) %>%
      mutate(
        distribution = forcats::as_factor(distribution)
      )
  })
  
  output$plot = renderPlot({      
    g = ggplot(d(), aes(x=p, y=density, color=distribution)) +
      geom_line(size=1.5) +
      geom_ribbon(aes(ymax=density, fill=distribution), ymin=0, alpha=0.5)
    
    if (input$bw)
      g = g + theme_bw()
    
    if (input$facet) 
      g = g + facet_wrap(~distribution)
    
    g
  })
  
  output$table = renderTable({
    d() %>%
      group_by(distribution) %>%
      summarize(
        mean = sum(p * density) / n(),
        median = p[(cumsum(density/n()) >= 0.5)][1],
        q025 = p[(cumsum(density/n()) >= 0.025)][1],
        q975 = p[(cumsum(density/n()) >= 0.975)][1]
      )
  })
}

thematic::thematic_shiny()
shinyApp(ui = ui, server = server)
