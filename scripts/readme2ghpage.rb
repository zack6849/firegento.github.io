#!/usr/bin/env ruby

# checkout the readme from the master branch
# `git checkout https://github.com/firegento/firegento-magesetup.git; git checkout master docs/features/overview.markdown`

path = `pwd`.gsub(/\n/, "")
readme_path = File.join(path, "convert.md")
index_path = File.join(path, "index.md")

# write the index readme file
File.open readme_path, "r" do |readme|
  File.open index_path, "w" do |index|

    # write the jekyll front matter
    index.puts "---"
    index.puts "layout: default"
    index.puts "bodyclass: about"

    ### PLEASE CHANGE HERE ###
    index.puts "id: PDF"
    index.puts "title: FireGento - PDF"
    #
    ### END ###
    index.puts "---"

    readme.readlines.each do |line|

      # convert backticks to liquid
      %w(bash ruby).each do |lang|
        line.gsub!("```#{lang}", "{% highlight #{lang} %}")
      end
      line.gsub!("```", "{% endhighlight %}")

      # convert headers so they are linkable
      if line =~ /^#+/
        leader = line[0, line.index(/\s/)]
        text = line[line.index(/\s./)..-1].strip
        line = "#{leader} #{text} {##{text.downcase.gsub(/\s/, "-")}}"
      end

      index.puts line
    end
  end
end

# remove the readme
# `git reset HEAD README.md; rm README.md`