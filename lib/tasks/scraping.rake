namespace :scraping do
  def parse_html(url)
    require 'open-uri'
    charset = nil
    html = URI.open(url) do |f|
      charset = f.charset
      f.read
    end
    return Nokogiri::HTML.parse(html, nil, charset)
  end

  desc '問題一覧をデータベースに追加する'
  task :add_problems_to_database => :environment do
    urls = ['d', 'c', 'b', 'a', 's'].map do |rank|
      "https://paiza.jp/challenges/ranks/#{rank}/info"
    end

    urls.each do |url|
      doc = parse_html(url)
      nodeset = doc.css('.problem-box')
      nodeset.map do |elem|
        # "challenge_336"みたいになっているので数字を抜き出す
        id = elem.attributes['id'].value[/challenge_(\d+)/, 1].to_i
        # title='D104:運賃の計算'など
        title = elem.css('.problem-box__header__title').text.chomp
        difficulty = elem.css('.problem-box__bottom > dl > dd:nth-child(10) > b > span').text.to_i

        rank, number, name = Problem.parse_title(title)
        problem = Problem.new(
          rank: rank,
          number: number,
          name: name,
          url: Problem.get_url_from_id(id),
          difficulty: difficulty,
        )
        problem.save
      end
    end
  end
end