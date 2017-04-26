#makes a dummy "input" data frame fro debugging reactive code from a non-reactive context

input <- data.frame(1)
input$s.mu = '6054'
input$component_name="Sierra"
input$pedon_pattern = '.'
input$upid_pattern = '.'
input$pedon_list=""
input$modal_pedon="307585:08SMM003"
input$thematic_field="clay"

input

s.comp <<- getMapunitComponents(input$s.mu)
s.pedons <<- getMapunitPedons(input$s.mu)
