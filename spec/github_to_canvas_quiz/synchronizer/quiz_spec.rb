# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Synchronizer::Quiz do
  let(:initial_mock_db) do
    {
      'quiz' => { 'id' => 123 },
      'questions' => [
        { 'id' => 1 },
        { 'id' => 2 },
        { 'id' => 3 }
      ]
    }
  end

  let(:client) do
    client = instance_double(GithubToCanvasQuiz::CanvasAPI::Client)

    allow(client).to receive(:get_single_quiz) do
      mock_db['quiz']
    end

    allow(client).to receive(:update_quiz) do |_course_id, quiz_id, payload|
      mock_db['quiz'] = payload['quiz'].merge({ 'id' => quiz_id })
      mock_db['quiz']
    end

    allow(client).to receive(:list_questions) do
      mock_db['questions']
    end

    allow(client).to receive(:update_question) do |_course_id, quiz_id, question_id, payload|
      updated_question = payload['question'].merge({ 'quiz_id' => quiz_id, 'id' => question_id })
      mock_db['questions'] = mock_db['questions'].map do |question|
        question['id'] == question_id ? updated_question : question
      end
      updated_question
    end

    allow(client).to receive(:create_question) do |_course_id, quiz_id, payload|
      last_id = mock_db['questions'].last['id']
      new_question = payload['question'].merge({ 'quiz_id' => quiz_id, 'id' => last_id + 1 })
      mock_db['questions'] = [*mock_db['questions'], new_question]
      new_question
    end

    allow(client).to receive(:delete_question) do |_course_id, _quiz_id, question_id|
      mock_db['questions'] = mock_db['questions'].filter do |question|
        question['id'] != question_id
      end
    end

    client
  end

  def mock_db
    @mock_db ||= initial_mock_db
  end

  def reset_mock_db!
    @mock_db = initial_mock_db
  end

  def snapshot_output(path)
    git = Git.open(path)

    snapshot_commits = git.log.filter do |commit|
      commit.message == 'AUTO: Created Canvas snapshot'
    end

    # Commits are logged in reverse order
    snapshot_commits.reverse.map do |commit|
      # checkout commits with snapshot data and read the snapshot file from that commit
      git.checkout(commit)
      json_backup_file = File.join(path, '.canvas-snapshot.json')
      JSON.parse(File.read(json_backup_file))
    end
  end


  before do
    reset_mock_db!
  end

  it 'raises an error if the directory does not exist' do
    expect { described_class.new(client, 'bad/path') }.to raise_error(GithubToCanvasQuiz::DirectoryNotFoundError)
  end

  describe '#sync' do
    context 'with a quiz and questions that exist in Canvas' do
      let(:quiz) do
        GithubToCanvasQuiz::Model::Quiz.new(id: 123, course_id: 1234, title: 'Test Quiz', description: '<p>Description</p>')
      end

      let(:question1) do
        GithubToCanvasQuiz::Model::Question.new(quiz_id: 123, course_id: 1234, id: 1, type: 'short_answer_question', name: 'Question 1', description: '<p>Description</p>', answers: [GithubToCanvasQuiz::Model::Answer::ShortAnswer.new(title: 'Correct', text: 'Answer', comments: '')], distractors: [])
      end

      let(:question2) do
        GithubToCanvasQuiz::Model::Question.new(quiz_id: 123, course_id: 1234, id: 2, type: 'short_answer_question', name: 'Question 2', description: '<p>Description</p>', answers: [GithubToCanvasQuiz::Model::Answer::ShortAnswer.new(title: 'Correct', text: 'Answer', comments: '')], distractors: [])
      end

      # testing side effects of backup_canvas_to_json!
      it 'saves a snapshot of the Canvas data before and after updating' do
        in_temp_dir do |path|
          create_quiz_repo!(path, quiz, question1, question2)

          snapshot_before = mock_db.clone
          synchronizer = described_class.new(client, path)
          synchronizer.sync
          snapshot_after = mock_db.clone

          expect(snapshot_output(path)).to match_array([snapshot_before, snapshot_after])
        end
      end

      # testing side effects of sync_quiz!
      it 'updates the quiz on Canvas' do
        in_temp_dir do |path|
          create_quiz_repo!(path, quiz, question1, question2)
          synchronizer = described_class.new(client, path)
          synchronizer.sync
          expect(client).to have_received(:update_quiz).with(1234, 123, { 'quiz' => quiz.to_h })
        end
      end

      # testing side effects of sync_questions!
      it 'updates the questions on Canvas' do
        in_temp_dir do |path|
          create_quiz_repo!(path, quiz, question1, question2)
          synchronizer = described_class.new(client, path)
          synchronizer.sync
          expect(client).to have_received(:update_question).with(1234, 123, 1, { 'question' => question1.to_h })
          expect(client).to have_received(:update_question).with(1234, 123, 2, { 'question' => question2.to_h })
        end
      end

      # testing side effects of sync_questions!
      it 'deletes questions on Canvas that are not in the directory' do
        in_temp_dir do |path|
          create_quiz_repo!(path, quiz, question1, question2)
          synchronizer = described_class.new(client, path)
          synchronizer.sync
          expect(client).to have_received(:delete_question).with(1234, 123, 3)
        end
      end
    end

    context 'with a quiz and question that does not exist in Canvas' do
      let(:quiz) do
        GithubToCanvasQuiz::Model::Quiz.new(id: 123, course_id: 1234, title: 'Test Quiz', description: '<p>Description</p>')
      end

      let(:question) do
        GithubToCanvasQuiz::Model::Question.new(quiz_id: 123, course_id: 1234, type: 'short_answer_question', name: 'Question 1', description: '<p>Description</p>', answers: [GithubToCanvasQuiz::Model::Answer::ShortAnswer.new(title: 'Correct', text: 'Answer', comments: '')], distractors: [])
      end

      # testing side effects of backup_canvas_to_json!
      it 'saves a snapshot of the Canvas data before and after updating' do
        in_temp_dir do |path|
          create_quiz_repo!(path, quiz, question)

          snapshot_before = mock_db.clone
          synchronizer = described_class.new(client, path)
          synchronizer.sync
          snapshot_after = mock_db.clone

          expect(snapshot_output(path)).to match_array([snapshot_before, snapshot_after])
        end
      end

      # testing side effects of sync_quiz!
      it 'updates the quiz on Canvas' do
        in_temp_dir do |path|
          create_quiz_repo!(path, quiz, question)
          synchronizer = described_class.new(client, path)
          synchronizer.sync
          expect(client).to have_received(:update_quiz).with(1234, 123, { 'quiz' => quiz.to_h })
        end
      end

      # testing side effects of sync_questions!
      it 'creates the question on Canvas' do
        in_temp_dir do |path|
          create_quiz_repo!(path, quiz, question)
          synchronizer = described_class.new(client, path)
          synchronizer.sync
          expect(client).to have_received(:create_question).with(1234, 123, { 'question' => question.to_h })
        end
      end

      # testing side effects of sync_questions!
      it 'updates the markdown file for the created question' do
        in_temp_dir do |path|
          create_quiz_repo!(path, quiz, question)
          synchronizer = described_class.new(client, path)
          synchronizer.sync

          question_path = File.join(path, 'questions', '00.md')
          parsed = FrontMatterParser::Parser.parse_file(question_path)
          expect(parsed['id']).to be(mock_db['questions'].last['id'])
        end
      end
    end
  end
end
