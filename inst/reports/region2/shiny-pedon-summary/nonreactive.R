#makes a dummy "input" data frame fro debugging reactive code from a non-reactive context

input <- data.frame(1)
input$s.mu = '.'
input$component_name = "."
input$pedon_pattern = '.'
input$upid_pattern = '.'
input$phase_pattern = "*"
input$taxon_kind = "any"
input$pedon_list = ""
input$thematic_field="clay"
#input$modal_pedon = "pedonrecordid:userpedonid" #note: this is dataset specific

s.comp <<- getMapunitComponents(input$s.mu)
s.pedons <<- getMapunitPedons(input$s.mu)
