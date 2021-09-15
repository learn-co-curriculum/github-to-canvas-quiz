# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Synchronizer::Repo do
  let(:client) do
    client = instance_double(GithubToCanvasQuiz::CanvasAPI::Client)
    allow(client).to receive(:update_quiz).and_return({ 'id' => 123 })
    allow(client).to receive(:update_question).and_return({ 'id' => 1 })
    allow(client).to receive(:delete_question)
    allow(client).to receive(:list_questions).and_return(
      [
        {
          'id' => 1
        },
        {
          'id' => 2
        },
        {
          'id' => 3
        }
      ]
    )
    client
  end

  let(:synchronizer) { described_class.new(client) }

  describe '#sync' do
    let(:tmp_path) { 'spec/tmp' }

    before do
      Dir.mkdir(tmp_path) unless File.directory? tmp_path
      quiz = "---\nid: 123\ncourse_id: 1234\n---\n\n# Test Quiz\n\nDescription\n"
      File.write("#{tmp_path}/README.md", quiz)
      Dir.mkdir("#{tmp_path}/questions")
      question1 = "---\nquiz_id: 123\ncourse_id: 1234\nid: 1\ntype: short_answer_question\n---\n\n# Question 1\n\nDescription\n\n## Correct\n\nAnswer\n"
      question2 = "---\nquiz_id: 123\ncourse_id: 1234\nid: 2\ntype: short_answer_question\n---\n\n# Question 2\n\nDescription\n\n## Correct\n\nAnswer\n"
      File.write("#{tmp_path}/questions/00.md", question1)
      File.write("#{tmp_path}/questions/01.md", question2)
    end

    after do
      FileUtils.rm_rf("#{tmp_path}/.", secure: true)
    end

    it 'raises an error if the directory does not exist' do
      expect { synchronizer.sync('bad/path') }.to raise_error(GithubToCanvasQuiz::DirectoryNotFoundError)
    end

    it 'syncs a quiz and questions in the directory' do
      synchronizer.sync(tmp_path)
      expect(client).to have_received(:update_quiz).with(1234, 123, {
        'quiz' => include({
          'title' => 'Test Quiz',
          'description' => '<p>Description</p>'
        })
      })
      expect(client).to have_received(:update_question).with(1234, 123, 1, {
        'question' => {
          'question_name' => 'Question 1',
          'question_text' => '<p>Description</p>',
          'question_type' => 'short_answer_question',
          'points_possible' => 1,
          'neutral_comments_html' => '',
          'answers' => [
            {
              'answer_html' => '<p>Answer</p>',
              'answer_weight' => 100,
              'answer_comments' => ''
            }
          ],
          'matching_answer_incorrect_matches' => ''
        }
      })
      expect(client).to have_received(:update_question).with(1234, 123, 2, {
        'question' => {
          'question_name' => 'Question 2',
          'question_text' => '<p>Description</p>',
          'question_type' => 'short_answer_question',
          'points_possible' => 1,
          'neutral_comments_html' => '',
          'answers' => [
            {
              'answer_html' => '<p>Answer</p>',
              'answer_weight' => 100,
              'answer_comments' => ''
            }
          ],
          'matching_answer_incorrect_matches' => ''
        }
      })
      expect(client).to have_received(:delete_question).with(1234, 123, 3)
    end
  end
end
