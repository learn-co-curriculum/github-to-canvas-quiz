# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Synchronizer::Question do
  let(:client) do
    client = instance_double(GithubToCanvasQuiz::CanvasAPI::Client)
    allow(client).to receive(:create_question).and_return({ 'id' => 1 })
    allow(client).to receive(:update_question).and_return({ 'id' => 1 })
    client
  end

  let(:synchronizer) { described_class.new(client) }

  describe '#sync' do
    let(:tmp_path) { 'spec/tmp' }

    it 'raises an error if the path does not exist' do
      expect { synchronizer.sync('bad/path/question/00.md') }.to raise_error(GithubToCanvasQuiz::FileNotFoundError)
    end

    context 'with a question that has an id' do
      before do
        Dir.mkdir("#{tmp_path}/questions") unless File.directory? "#{tmp_path}/questions"
        question = "---\ncourse_id: 1234\nquiz_id: 123\nid: 1\ntype: short_answer_question\n---\n\n# Question 1\n\nDescription\n\n## Correct\n\nAnswer\n"
        File.write("#{tmp_path}/questions/00.md", question)
      end

      after do
        FileUtils.rm_rf("#{tmp_path}/.", secure: true)
      end

      it 'uses the CanvasAPI client to update the question' do
        synchronizer.sync("#{tmp_path}/questions/00.md")
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
      end
    end

    context 'with a question that does not have an id' do
      before do
        Dir.mkdir("#{tmp_path}/questions") unless File.directory? "#{tmp_path}/questions"
        question = "---\ncourse_id: 1234\nquiz_id: 123\ntype: short_answer_question\n---\n\n# Question 1\n\nDescription\n\n## Correct\n\nAnswer\n"
        File.write("#{tmp_path}/questions/00.md", question)
      end

      after do
        FileUtils.rm_rf("#{tmp_path}/.", secure: true)
      end

      it 'uses the CanvasAPI client to create the question' do
        synchronizer.sync("#{tmp_path}/questions/00.md")
        expect(client).to have_received(:create_question).with(1234, 123, {
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
      end

      it 'saves the question id to the file' do
        synchronizer.sync("#{tmp_path}/questions/00.md")
        output = "---\ncourse_id: 1234\nquiz_id: 123\nid: 1\ntype: short_answer_question\n---\n\n# Question 1\n\nDescription\n\n## Correct\n\nAnswer\n"
        expect(File.read("#{tmp_path}/questions/00.md")).to eq(output)
      end
    end

    context 'with a question that does not have a quiz_id or course_id' do
      before do
        Dir.mkdir("#{tmp_path}/questions") unless File.directory? "#{tmp_path}/questions"
        quiz = "---\ncourse_id: 1234\nid: 123\n---\n\n# Question 1\n\nDescription\n\n## Correct\n\nAnswer\n"
        File.write("#{tmp_path}/README.md", quiz)
        question = "---\ntype: short_answer_question\n---\n\n# Question 1\n\nDescription\n\n## Correct\n\nAnswer\n"
        File.write("#{tmp_path}/questions/00.md", question)
      end

      after do
        FileUtils.rm_rf("#{tmp_path}/.", secure: true)
      end

      it 'uses the CanvasAPI client to create the question' do
        synchronizer.sync("#{tmp_path}/questions/00.md")
        expect(client).to have_received(:create_question).with(1234, 123, {
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
      end

      it 'saves the question id to the file' do
        synchronizer.sync("#{tmp_path}/questions/00.md")
        output = "---\ncourse_id: 1234\nquiz_id: 123\nid: 1\ntype: short_answer_question\n---\n\n# Question 1\n\nDescription\n\n## Correct\n\nAnswer\n"
        expect(File.read("#{tmp_path}/questions/00.md")).to eq(output)
      end
    end
  end
end
