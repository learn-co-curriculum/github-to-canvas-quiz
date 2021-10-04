# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Model::Quiz do
  let(:quiz) do
    described_class.new(
      course_id: 4236,
      id: 18396,
      repo: 'phase-2-quiz-client-side-routing',
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
      header = <<~HTML
        <div id='git-data-element' data-org='learn-co-curriculum' data-repo='phase-2-quiz-client-side-routing'></div>
        <header class='fis-header'>
          <a class='fis-git-link' href='https://github.com/learn-co-curriculum/phase-2-quiz-client-side-routing/issues/new' target='_blank' rel='noopener'><img id='issue-img' title='Create New Issue' alt='Create New Issue' /></a>
        </header>
      HTML

      expect(quiz.to_h).to eq({
        'title' => 'Client-Side Routing Quiz',
        'description' => "#{header}\n<p><span>It's time to check your knowledge!</span></p>\n<p><span>If you don't know..</span></p>",
        'quiz_type' => 'assignment',
        'shuffle_answers' => true,
        'hide_results' => nil,
        'show_correct_answers_last_attempt' => true,
        'allowed_attempts' => 3,
        'scoring_policy' => 'keep_highest',
        'one_question_at_a_time' => true
      })
    end
  end
end
