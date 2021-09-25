# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Parser::Canvas::Question do
  describe '#load' do
    let(:client) do
      GithubToCanvasQuiz::CanvasAPI::Client.new(api_key: ENV['CANVAS_API_KEY'], host: ENV['CANVAS_API_PATH'])
    end

    context 'with a multiple choice question' do
      it 'creates a Model::Question instance with the correct data' do
        VCR.use_cassette 'question_multiple_choice' do
          data = client.get_single_question(4091, 21982, 144188)
          data.merge!({ 'course_id' => 4091, 'quiz_id' => 21982 })
          expect(described_class.new(data).parse).to have_attributes(
            course_id: 4091,
            quiz_id: 21982,
            id: 144188,
            type: 'multiple_choice_question',
            name: 'Question',
            description: '<p>Question</p>',
            answers: [
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::MultipleChoice,
                title: 'Correct',
                text: "<p>Answer 1</p>\n<p>\u00a0</p>\n<p>ok!</p>",
                comments: '<p>Answer 1 comment</p>'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::MultipleChoice,
                title: 'Incorrect',
                text: "<p>Answer 2</p>\n<p>\u00a0</p>\n<p>ok!</p>",
                comments: '<p>Answer 2 comment</p>'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::MultipleChoice,
                title: 'Incorrect',
                text: "<p>Answer 3</p>\n<p>\u00a0</p>\n<p>ok!</p>",
                comments: '<p>Answer 3 comment</p>'
              )
            ],
            distractors: []
          )
        end
      end
    end

    context 'with a matching question' do
      it 'creates a Question instance with the correct data' do
        VCR.use_cassette 'question_matching' do
          data = client.get_single_question(4091, 21982, 144189)
          data.merge!({ 'course_id' => 4091, 'quiz_id' => 21982 })
          expect(described_class.new(data).parse).to have_attributes(
            course_id: 4091,
            quiz_id: 21982,
            id: 144189,
            type: 'matching_question',
            name: 'Matching Question',
            description: '<p>Description</p>',
            answers: [
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::Matching,
                title: 'Correct',
                text: 'Answer 1',
                comments: '',
                left: 'Answer 1',
                right: 'Value 1'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::Matching,
                title: 'Correct',
                text: 'Answer 2',
                comments: '',
                left: 'Answer 2',
                right: 'Value 2'
              )
            ],
            distractors: ['Incorrect 1', 'Incorrect 2']
          )
        end
      end
    end

    context 'with a fill in multiple blanks question' do
      it 'creates a Question instance with the correct data' do
        VCR.use_cassette 'question_fill_in_multiple_blanks' do
          data = client.get_single_question(3297, 12020, 130145)
          data.merge!({ 'course_id' => 3297, 'quiz_id' => 12020 })
          expect(described_class.new(data).parse).to have_attributes(
            course_id: 3297,
            quiz_id: 12020,
            id: 130145,
            type: 'fill_in_multiple_blanks_question',
            name: 'Fundamentals: Logical Operators',
            description: "<p>How do we declare JavaScript's 3 logical operators?\u00a0</p>\n<p>[value1] AND</p>\n<p>[value2] OR</p>\n<p>[value3] NOT</p>",
            sources: [
              {
                'name' => 'Logical Operators',
                'url' => 'https://learning.flatironschool.com/courses/3297/pages/logical-operators?module_item_id=143560'
              }
            ],
            answers: [
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::FillInMultipleBlanks,
                title: 'Correct',
                text: '&&',
                comments: '<p>Nice one!</p>',
                blank_id: 'value1'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::FillInMultipleBlanks,
                title: 'Correct',
                text: '||',
                comments: '<p>Correct!</p>',
                blank_id: 'value2'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::FillInMultipleBlanks,
                title: 'Correct',
                text: '!',
                comments: '<p>Nailed it!</p>',
                blank_id: 'value3'
              )
            ],
            distractors: []
          )
        end
      end
    end

    context 'with a multiple dropdowns question' do
      it 'creates a Question instance with the correct data' do
        VCR.use_cassette 'question_multiple_dropdowns' do
          data = client.get_single_question(3299, 19086, 120510)
          data.merge!({ 'course_id' => 3299, 'quiz_id' => 19086 })
          expect(described_class.new(data).parse).to have_attributes(
            course_id: 3299,
            quiz_id: 19086,
            id: 120510,
            type: 'multiple_dropdowns_question',
            name: 'Question 5',
            description: "<pre><code>\nmodule Talk\n  module Phrases\n    def hello\n      \"Hello!\"\n    end\n\n    def goodbye\n      \"Good bye!\"\n    end\n  end\n\n  module Teachers\n    def teach\n      \"Repeat after me.\"\n    end\n  end\nend<br>\n</code></pre>\n<div>\n<div><span>The code sample above is an example of [a1]</span><span> modules. To access the Teachers module to include it in a class, we would type include [a2]</span><span>.</span></div>\n</div>",
            sources: [
              {
                'name' => 'Modules',
                'url' => 'https://github.com/learn-co-curriculum/phase-3-ruby-oo-inheritance-modules'
              }
            ],
            answers: [
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::MultipleDropdowns,
                title: 'Correct',
                text: 'nested',
                comments: 'Correct! Both <code>Teachers</code> and <code>Phrases</code> are nested inside of <code>Talk</code>. They can be accessed using <code>::</code>.',
                blank_id: 'a1'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::MultipleDropdowns,
                title: 'Incorrect',
                text: 'subclass inherited',
                comments: "There aren't any classes, nor any subclass inheritance, in the syntax above. You might want to review the resource/s for this question.",
                blank_id: 'a1'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::MultipleDropdowns,
                title: 'Incorrect',
                text: "I don't know",
                comments: "Be sure to study the source/s for this question. You'll get it next time.",
                blank_id: 'a1'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::MultipleDropdowns,
                title: 'Correct',
                text: 'Talk::Teachers',
                comments: 'Correct! To <code>include</code> the <code>Teachers</code> module, we need to access it using <code>::</code> on the module that contains it.',
                blank_id: 'a2'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::MultipleDropdowns,
                title: 'Incorrect',
                text: 'Teachers::Talk',
                comments: 'When using <code>::</code> to access a nested module, we put the module that contains the other module on the left side of the double colon.',
                blank_id: 'a2'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Model::Answer::MultipleDropdowns,
                title: 'Incorrect',
                text: 'Talk.Teachers',
                comments: "Not quite. This looks more like we're trying to call a method on <code>Talk</code>.",
                blank_id: 'a2'
              )
            ],
            distractors: []
          )
        end
      end
    end
  end
end
