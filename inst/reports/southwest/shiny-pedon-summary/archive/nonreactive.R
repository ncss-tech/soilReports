#makes a dummy "input" data frame fro debugging reactive code from a non-reactive context

input <- data.frame(1)
input$s.mu = '.*'
input$component_name = ""
input$pedon_pattern = ''
input$upid_pattern = ''
input$phase_pattern = ""
input$taxon_kind = "any"
input$pedon_list = ""
input$thematic_field="clay"
#input$modal_pedon = "pedonrecordid:userpedonid" #note: this is dataset specific

#s.comp <<- getMapunitComponents(input$s.mu)
s.pedons <<- getMapunitPedons(input$s.mu)
p <- getPedonsByPattern(input$pedon_pattern,input$upid_pattern,input$pedon_list,input$taxon_kind,input$phase_pattern)

groupedProfilePlot(p, groups = 'taxonname', label='upedonid', break.style="line",
                   print.id = TRUE, id.style = 'side', cex.id=1.2, 
                   cex.names=1, cex.depth.axis=1.25, y.offset=7, 
                   axis.line.offset=-3.0, group.name.cex=1, color=input$thematic_field,
                   width=0.1, shrink=T, shrink.cutoff=3)
