# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Model::Quiz do
  let(:quiz) do
    described_class.new(
      course_id: 4236,
      id: 18396,
      title: 'Client-Side Routing Quiz',
      description: "<p><span>It's time to check your knowledge!</span></p>\n<p><span>If you don't know..</span></p>"
    )
  end

  describe '#to_markdown' do
    it 'produces the correct markdown' do
      match = File.read('spec/fixtures/markdown/quiz.md')
      expect(quiz.to_markdown).to eq(match)
    end
  end

  describe '#to_h' do
    it 'produces the correct hash' do
      expect(quiz.to_h).to eq({
        'title' => 'Client-Side Routing Quiz',
        'description' => "<p><span>It's time to check your knowledge!</span></p>\n<p><span>If you don't know..</span></p>",
        'quiz_type' => 'assignment',
        'shuffle_answers' => true,
        'hide_results' => 'until_after_last_attempt',
        'show_correct_answers_last_attempt' => true,
        'allowed_attempts' => 3,
        'scoring_policy' => 'keep_highest',
        'one_question_at_a_time' => true
      })
    end
  end
end
