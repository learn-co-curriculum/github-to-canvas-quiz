# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Answer::MultipleChoice do
  describe '.from_canvas' do
    it 'creates an instance of the class with the correct attributes' do
      answer = described_class.from_canvas({
        'id' => 3673,
        'text' => '',
        'html' => '<pre><code>const header = &lt;h1 className="main"&gt;Hello from React!&lt;/h1&gt;;<br><br>ReactDOM.render(header, document.querySelector("#container")); </code></pre>',
        'comments' => '',
        'comments_html' => "<p>Correct!&nbsp;</p>\n<p>With declarative syntax, we are able to leave the&nbsp;determination of<span>&nbsp;</span><em>how</em><span>&nbsp;</span>to get to the end result up to the program! Therefore, we <em>don't</em> need to lay out every step that needs to happen, like we do with imperative syntax.</p>",
        'weight' => 100.0
      })
      expect(answer).to have_attributes(
        title: 'Correct',
        text: '<pre><code>const header = &lt;h1 className="main"&gt;Hello from React!&lt;/h1&gt;;<br><br>ReactDOM.render(header, document.querySelector("#container")); </code></pre>',
        comments: "<p>Correct!&nbsp;</p>\n<p>With declarative syntax, we are able to leave the&nbsp;determination of<span>&nbsp;</span><em>how</em><span>&nbsp;</span>to get to the end result up to the program! Therefore, we <em>don't</em> need to lay out every step that needs to happen, like we do with imperative syntax.</p>"
      )
    end
  end

  describe 'instance methods' do
    let(:answer) do
      described_class.new(
        text: '<p>useParams</p>',
        comments: '<p><span>We use the <a class="external" href="https://reactrouter.com/web/api/Hooks/useparams" target="_blank"><code>useParams</code><span class="screenreader-only">&nbsp;(Links to an external site.)</span></a> hook to get the dynamic </span><code>params</code><span> from the URL.</span></p>',
        title: 'Incorrect'
      )
    end

    describe '#to_markdown' do
      it 'produces the correct markdown' do
        match = File.read('spec/fixtures/markdown/answer/multiple_choice_question.md')
        expect(answer.to_markdown.chomp).to eq(match.chomp)
      end
    end

    describe '#to_h' do
      it 'produces the correct hash' do
        expect(answer.to_h).to eq({
          'answer_html' => '<p>useParams</p>',
          'answer_weight' => 0,
          'answer_comment_html' => '<p><span>We use the <a class="external" href="https://reactrouter.com/web/api/Hooks/useparams" target="_blank"><code>useParams</code><span class="screenreader-only">&nbsp;(Links to an external site.)</span></a> hook to get the dynamic </span><code>params</code><span> from the URL.</span></p>'
        })
      end
    end
  end
end
