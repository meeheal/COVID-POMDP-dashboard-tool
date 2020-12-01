plotstargraph <- function(sol) {
  pg <- policy_graph(sol)
  mylevels <- levels(sol$solution$initial_pg_node)
  mylevels <- as.numeric(mylevels)
  mylevels[1:(c(sol$solution$initial_pg_node) - 1)] <- 
    mylevels[1:(c(sol$solution$initial_pg_node) - 1)] + 1
  mylevels[(c(sol$solution$initial_pg_node) + 1):length(mylevels)] <- 
    mylevels[(c(sol$solution$initial_pg_node) + 1):length(mylevels)] - 1
  mylevels[sol$solution$initial_pg_node] = 1
  pg <- permute(pg, mylevels)
  V(pg)$name <- vertex_attr(pg)$label
  E(pg)$name <- paste(1:length(E(pg)), abbreviate(edge_attr(pg)$label))
  edge_attr(pg)$label <- abbreviate(edge_attr(pg)$label)
  for (nod in 1:length(V(pg))) {
    V(pg)[nod]$title <- paste(V(pg)[nod]$label, knitr::kable(cbind(belief = V(pg)$pie[[nod]][V(pg)$pie[[nod]] > 0]), digits = 3, format = "html")) }
  V(pg)$color <- lighten(sapply(seq(length(V(pg))), FUN = function(i)
    grDevices::rgb(t(grDevices::col2rgb(V(pg)$pie.color[[1]])
                     %*% V(pg)$pie[[i]])/255.001)), 0.18)
  pg <- make_ego_graph(pg, order = 1,
                       nodes = 1, 
                       mode = "out")[[1]]
  for (nod in 1:length(V(pg))) {
    V(pg)[nod]$title <- paste(V(pg)[nod]$label, knitr::kable(cbind(belief = V(pg)$pie[[nod]][V(pg)$pie[[nod]] > 0]), digits = 3, format = "html")) }
  visiGraph <- visNetwork::visIgraph(pg, idToLabel = FALSE, smooth = smooth)
  nodes <- visiGraph$x$nodes
  edges <- visiGraph$x$edges
  visNetwork::visIgraph(pg, idToLabel = FALSE, layout = "layout_as_star", smooth = smooth) %>%
    visEdges( font = list(size = 12, vadjust = 0)) %>%
    visNetwork::visOptions(highlightNearest = list(enabled = TRUE, degree = 0),
                           nodesIdSelection = FALSE, ) %>%
    visLayout(improvedLayout = FALSE) %>%
    visInteraction(tooltipDelay = 915, navigationButtons = FALSE, tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;white-space: nowrap;
  font-family: cursive;font-size:18px;font-color:purple;background-color: red;')
}
