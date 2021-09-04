library(shiny)

# サーバロジックの定義。ヒストグラムを描く
shinyServer(function(input, output) {
  
  # ヒストグラムを描くための式。
  # この式は renderPlot にラップされている。つまり、
  #
  #  1) これは "reactive" であり、入力が変更されると
  #     自動的に再実行される
  #  2) この出力タイプは plot である
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # 指定された階級数(bin)でヒストグラムを描く
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
})
# アプリケーションの UI 定義。ヒストグラムを描く
shinyUI(fluidPage(
  
  # アプリケーションタイトル
  titlePanel("Hello Shiny!"),
  
  # サイドバー。階級数(bin)のためのスライダー
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # 生成された分布のプロットを表示する
    mainPanel(
      plotOutput("distPlot")
    )
  )
))

