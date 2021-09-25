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

    let(:tmp_path) { 'spec/tmp' }

    let(:builder) do
      described_class.new(client, 4091, 21982, tmp_path)
    end

    before do
      Dir.mkdir(tmp_path) unless File.directory? tmp_path
    end

    after do
      FileUtils.rm_rf("#{tmp_path}/.", secure: true)
    end

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
      builder.build
      expect(File.read("#{tmp_path}/README.md")).to eq(md)
    end

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
      builder.build
      expect(File.read("#{tmp_path}/questions/00.md")).to eq(question1_md)
      expect(File.read("#{tmp_path}/questions/01.md")).to eq(question2_md)
    end
  end
end
