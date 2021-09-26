# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Builder::Quiz do
  describe '#build' do
    let(:quiz_data) do
      description = <<~HTML
        <div id='git-data-element' data-org='learn-co-curriculum' data-repo='example-repo'></div>
        <header class='fis-header'>
          <a class='fis-git-link' href='https://github.com/learn-co-curriculum/example-repo/issues/new' target='_blank' rel='noopener'><img id='issue-img' title='Create New Issue' alt='Create New Issue' /></a>
        </header>
        <p>Description</p>
      HTML
      {
        'id' => 21982,
        'title' => 'Quiz',
        'description' => description
      }
    end

    let(:questions_data) do
      [
        {
          'id' => 1,
          'question_type' => 'true_false_question',
          'question_name' => 'Question 1',
          'question_text' => '<p>Here is your question</p>',
          'neutral_comments_html' => '<strong>Source/s:</strong><a href="http://example.com">Source 1</a>',
          'answers' => [
            {
              'weight' => 100,
              'text' => 'True',
              'comments_html' => '<p>Correct!</p>'
            },
            {
              'weight' => 0,
              'text' => 'False',
              'comments_html' => '<p>Wrong!</p>'
            }
          ]
        },
        {
          'id' => 2,
          'question_type' => 'true_false_question',
          'question_name' => 'Question 1',
          'question_text' => '<p>Here is your question</p>',
          'neutral_comments_html' => '<strong>Source/s:</strong><a href="http://example.com">Source 1</a>',
          'answers' => [
            {
              'weight' => 100,
              'text' => 'True',
              'comments_html' => '<p>Correct!</p>'
            },
            {
              'weight' => 0,
              'text' => 'False',
              'comments_html' => '<p>Wrong!</p>'
            }
          ]
        }
      ]
    end

    let(:client) do
      instance_double(
        GithubToCanvasQuiz::CanvasAPI::Client,
        get_single_quiz: quiz_data,
        list_questions: questions_data
      )
    end

    # testing side effects of prepare_directory!
    it 'creates a directory if one does not exist at the given path' do
      in_temp_dir do |path|
        new_directory = File.join(path, '/new-directory')

        expect(Pathname(new_directory)).not_to exist

        builder = described_class.new(client, 4091, 21982, new_directory)
        builder.build

        expect(Pathname(new_directory)).to exist
      end
    end

    # testing side effects of sync_quiz!
    it 'outputs a README.md file for the quiz in the given directory' do
      md = <<~MARKDOWN
        ---
        id: 21982
        course_id: 4091
        repo: example-repo
        ---

        # Quiz

        Description
      MARKDOWN

      in_temp_dir do |path|
        builder = described_class.new(client, 4091, 21982, path)
        builder.build
        readme_file = File.join(path, 'README.md')
        expect(File.read(readme_file)).to eq(md)
      end
    end

    # testing side effects of sync_questions!
    it 'outputs a .md file for each question to a /questions subfolder in the given directory' do
      question1_md = <<~MARKDOWN
        ---
        course_id: 4091
        quiz_id: 21982
        id: 1
        type: true_false_question
        sources:
        - name: Source 1
          url: http://example.com
        ---

        # Question 1

        Here is your question

        ## Correct

        True

        > Correct!

        ## Incorrect

        False

        > Wrong!
      MARKDOWN

      question2_md = <<~MARKDOWN
        ---
        course_id: 4091
        quiz_id: 21982
        id: 2
        type: true_false_question
        sources:
        - name: Source 1
          url: http://example.com
        ---

        # Question 1

        Here is your question

        ## Correct

        True

        > Correct!

        ## Incorrect

        False

        > Wrong!
      MARKDOWN

      in_temp_dir do |path|
        builder = described_class.new(client, 4091, 21982, path)
        builder.build
        files = Dir["#{path}/questions/*.md"].map do |question_path|
          File.read(question_path)
        end
        expect(files).to eq([question1_md, question2_md])
      end
    end

    # testing side effects of backup_json!
    it 'outputs a JSON backup of the raw Canvas API data' do
      in_temp_dir do |path|
        builder = described_class.new(client, 4091, 21982, path)
        builder.build

        json_backup_file = File.join(path, '.canvas-snapshot.json')
        expect(Pathname(json_backup_file)).to exist

        json_data = JSON.parse(File.read(json_backup_file))
        expect(json_data).to eq({
          'quiz' => quiz_data,
          'questions' => questions_data
        })
      end
    end

    # testing side effects of commit!
    it 'initializes git in the project directory' do
      in_temp_dir do |path|
        builder = described_class.new(client, 4091, 21982, path)
        builder.build
        expect(Pathname(File.join(path, '.git'))).to exist
      end
    end

    it 'commits the README and question files' do
      in_temp_dir do |path|
        builder = described_class.new(client, 4091, 21982, path)
        builder.build

        git = Git.open(path)

        # git.status will raise if no commits have been made yet
        expect { git.status }.not_to raise_error

        tracked_files = git.status.reject(&:untracked)

        expect(tracked_files).to match_array(
          [
            have_attributes(path: 'README.md'),
            have_attributes(path: 'questions/00.md'),
            have_attributes(path: 'questions/01.md'),
            have_attributes(path: '.canvas-snapshot.json')
          ]
        )
      end
    end
  end
end
