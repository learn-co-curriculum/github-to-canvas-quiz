# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::MarkdownConverter do
  describe '#to_html' do
    it 'converts markdown to HTML' do
      md = "# Hello\n\nWorld\n"
      output = described_class.new(md).to_html
      expect(output).to eq("<h1>Hello</h1>\n\n<p>World</p>\n")
    end

    context 'with a fenced code block' do
      it 'converts markdown to HTML' do
        md = <<~MD
          ```rb
          def hello
            puts "World"
          end
          ```
        MD
        html = <<~HTML
          <div class="highlight"><pre class="highlight ruby"><code><span class="k">def</span> <span class="nf">hello</span>
            <span class="nb">puts</span> <span class="s2">"World"</span>
          <span class="k">end</span>
          </code></pre></div>
        HTML
        output = described_class.new(md).to_html
        expect(output.chomp).to eq(html.chomp)
      end
    end
  end
end
