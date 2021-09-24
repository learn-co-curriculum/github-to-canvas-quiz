# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Model::Answer::MultipleChoice do
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
