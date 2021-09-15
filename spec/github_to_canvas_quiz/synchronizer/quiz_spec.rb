# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Synchronizer::Quiz do
  let(:client) do
    client = instance_double(GithubToCanvasQuiz::CanvasAPI::Client)
    allow(client).to receive(:create_quiz).and_return({ 'id' => 1 })
    allow(client).to receive(:update_quiz).and_return({ 'id' => 1 })
    client
  end

  let(:synchronizer) { described_class.new(client) }

  describe '#sync' do
    let(:tmp_path) { 'spec/tmp' }

    it 'raises an error if the path does not exist' do
      expect { synchronizer.sync('bad/path/README.md') }.to raise_error(GithubToCanvasQuiz::FileNotFoundError)
    end

    context 'with a quiz that has an id' do
      before do
        Dir.mkdir(tmp_path) unless File.directory? tmp_path
        quiz = "---\nid: 123\ncourse_id: 1234\n---\n\n# Test Quiz\n\nDescription\n"
        File.write("#{tmp_path}/README.md", quiz)
      end

      after do
        FileUtils.rm_rf("#{tmp_path}/.", secure: true)
      end

      it 'uses the CanvasAPI client to update the quiz' do
        synchronizer.sync("#{tmp_path}/README.md")
        expect(client).to have_received(:update_quiz).with(1234, 123, {
          'quiz' => include({
            'title' => 'Test Quiz',
            'description' => '<p>Description</p>'
          })
        })
      end
    end

    context 'with a quiz that does not have an id' do
      before do
        Dir.mkdir(tmp_path) unless File.directory? tmp_path
        quiz = "---\ncourse_id: 1234\n---\n\n# Test Quiz\n\nDescription\n"
        File.write("#{tmp_path}/README.md", quiz)
      end

      after do
        FileUtils.rm_rf("#{tmp_path}/.", secure: true)
      end

      it 'uses the CanvasAPI client to create the quiz' do
        synchronizer.sync("#{tmp_path}/README.md")
        expect(client).to have_received(:create_quiz).with(1234, {
          'quiz' => include({
            'title' => 'Test Quiz',
            'description' => '<p>Description</p>'
          })
        })
      end

      it 'saves the quiz id to the README.md file' do
        synchronizer.sync("#{tmp_path}/README.md")
        output = "---\nid: 1\ncourse_id: 1234\n---\n\n# Test Quiz\n\nDescription\n"
        expect(File.read("#{tmp_path}/README.md")).to eq(output)
      end
    end
  end
end
