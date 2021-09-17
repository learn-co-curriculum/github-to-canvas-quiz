# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Quiz do
  describe '.from_canvas' do
    it 'creates a Quiz instance with the correct data' do
      VCR.use_cassette 'quiz' do
        client = GithubToCanvasQuiz::CanvasAPI::Client.new(api_key: ENV['CANVAS_API_KEY'], host: ENV['CANVAS_API_PATH'])
        quiz = client.get_single_quiz(4091, 21982)
        expect(described_class.from_canvas(4091, quiz)).to have_attributes(
          course_id: 4091,
          id: quiz['id'],
          title: quiz['title'],
          description: quiz['description']
        )
      end
    end
  end

  describe '.from_markdown' do
    it 'creates a Quiz instance with the correct data' do
      input = File.read('spec/fixtures/markdown/quiz.md')
      expect(described_class.from_markdown(input)).to have_attributes(
        course_id: 4236,
        id: 18396,
        title: 'Client-Side Routing Quiz',
        description: "<p>It&#39;s time to check your knowledge!</p>\n\n<p>If you don&#39;t know..</p>"
      )
    end
  end

  describe '#to_markdown' do
    it 'produces the correct markdown' do
      output = described_class.new(
        course_id: 4236,
        id: 18396,
        title: 'Client-Side Routing Quiz',
        description: "<p><span>It's time to check your knowledge!</span></p>\n<p><span>If you don't know..</span></p>"
      ).to_markdown
      match = File.read('spec/fixtures/markdown/quiz.md')
      expect(output.chomp).to eq(match.chomp)
    end
  end

  describe '#to_h' do
    it 'produces the correct hash' do
      output = described_class.new(
        course_id: 4236,
        id: 18396,
        title: 'Client-Side Routing Quiz',
        description: "<p><span>It's time to check your knowledge!</span></p>\n<p><span>If you don't know..</span></p>"
      ).to_h
      expect(output).to eq({
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
