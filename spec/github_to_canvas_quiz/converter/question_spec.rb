# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Question do
  let(:multiple_choice) do
    described_class.new(
      course_id: 4091,
      quiz_id: 21962,
      id: 123906,
      type: 'multiple_choice_question',
      name: 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
      description: '<div><span>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</span></div>',
      comment: '<p><strong>Source/s: <a class="inline_disabled" href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565" target="_blank">Functions: Continued</a></strong></p>',
      answers: [
        GithubToCanvasQuiz::Converter::Answer::MultipleChoice.new(
          title: 'Correct',
          text: '<p>useHistory</p>',
          comments: ''
        ),
        GithubToCanvasQuiz::Converter::Answer::MultipleChoice.new(
          title: 'Incorrect',
          text: '<p>useParams</p>',
          comments: '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>'
        ),
        GithubToCanvasQuiz::Converter::Answer::MultipleChoice.new(
          title: 'Incorrect',
          text: '<p>useState</p>',
          comments: '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>'
        ),
        GithubToCanvasQuiz::Converter::Answer::MultipleChoice.new(
          title: 'Incorrect',
          text: '<p>I don&#39;t know.</p>',
          comments: '<p>Comment</p>'
        )
      ],
      distractors: []
    )
  end
  let(:matching) do
    described_class.new(
      course_id: 4091,
      quiz_id: 21962,
      id: 144189,
      type: 'matching_question',
      name: 'Matching Question',
      description: '<p>Match the value on the left to the correct value from the dropdown.</p>',
      comment: '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
      answers: [
        GithubToCanvasQuiz::Converter::Answer::Matching.new(
          title: 'Correct',
          text: 'Answer 1',
          comments: '',
          left: 'Answer 1',
          right: 'Value 1'
        ),
        GithubToCanvasQuiz::Converter::Answer::Matching.new(
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
  let(:true_false) do
    described_class.new(
      course_id: 4091,
      quiz_id: 21962,
      id: 144189,
      type: 'true_false_question',
      name: 'Question 1',
      description: '<p>Answer true</p>',
      comment: '',
      answers: [
        GithubToCanvasQuiz::Converter::Answer::TrueFalse.new(
          title: 'Correct',
          text: 'True',
          comments: ''
        ),
        GithubToCanvasQuiz::Converter::Answer::Matching.new(
          title: 'Incorrect',
          text: 'False',
          comments: ''
        )
      ],
      distractors: []
    )
  end
  let(:fill_in_multiple_blanks) do
    described_class.new(
      course_id: 3297,
      quiz_id: 12020,
      id: 130145,
      type: 'fill_in_multiple_blanks_question',
      name: 'Fundamentals: Logical Operators',
      description: "<p>How do we declare JavaScript&#39;s 3 logical operators?</p>\n\n<p>[value1] AND</p>\n\n<p>[value2] OR</p>\n\n<p>[value3] NOT</p>",
      comment: '<p><strong>Source/s:</strong> <a href="https://learning.flatironschool.com/courses/3297/pages/logical-operators?module_item_id=143560">Logical Operators</a></p>',
      answers: [
        GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '&&',
          comments: '<p>Nice one!</p>',
          blank_id: 'value1'
        ),
        GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '"&&"',
          comments: '<p>Nice one!</p>',
          blank_id: 'value1'
        ),
        GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '||',
          comments: '<p>Correct!</p>',
          blank_id: 'value2'
        ),
        GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '"||"',
          comments: '<p>Correct!</p>',
          blank_id: 'value2'
        ),
        GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '!',
          comments: '<p>Nailed it!</p>',
          blank_id: 'value3'
        ),
        GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks.new(
          title: 'Correct',
          text: '"!"',
          comments: '<p>Nailed it!</p>',
          blank_id: 'value3'
        )
      ],
      distractors: []
    )
  end

  describe '.from_canvas' do
    let(:client) do
      GithubToCanvasQuiz::CanvasAPI::Client.new(api_key: ENV['CANVAS_API_KEY'], host: ENV['CANVAS_API_PATH'])
    end

    context 'with a multiple choice question' do
      it 'creates a Question instance with the correct data' do
        VCR.use_cassette 'question_multiple_choice' do
          question = client.get_single_question(4091, 21982, 144188)
          expect(described_class.from_canvas(4091, 21982, question)).to have_attributes(
            course_id: 4091,
            quiz_id: 21982,
            id: question['id'],
            type: question['question_type'],
            name: question['question_name'],
            description: question['question_text'],
            comment: question['neutral_comments_html'],
            answers: [
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer::MultipleChoice,
                title: 'Correct',
                text: question['answers'][0]['html'],
                comments: question['answers'][0]['comments_html']
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer::MultipleChoice,
                title: 'Incorrect',
                text: question['answers'][1]['html'],
                comments: question['answers'][1]['comments_html']
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer::MultipleChoice,
                title: 'Incorrect',
                text: question['answers'][2]['html'],
                comments: question['answers'][2]['comments_html']
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
          question = client.get_single_question(4091, 21982, 144189)
          expect(described_class.from_canvas(4091, 21982, question)).to have_attributes(
            course_id: 4091,
            quiz_id: 21982,
            id: question['id'],
            type: question['question_type'],
            name: question['question_name'],
            description: question['question_text'],
            comment: question['neutral_comments_html'],
            answers: [
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer::Matching,
                title: 'Correct',
                text: question['answers'][0]['text'],
                comments: question['answers'][0]['comments_html'],
                left: question['answers'][0]['left'],
                right: question['answers'][0]['right']
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer::Matching,
                title: 'Correct',
                text: question['answers'][1]['text'],
                comments: question['answers'][1]['comments_html'],
                left: question['answers'][1]['left'],
                right: question['answers'][1]['right']
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
          question = client.get_single_question(3297, 12020, 130145)
          expect(described_class.from_canvas(3297, 12020, question)).to have_attributes(
            course_id: 3297,
            quiz_id: 12020,
            id: question['id'],
            type: question['question_type'],
            name: question['question_name'],
            description: question['question_text'],
            comment: question['neutral_comments_html'],
            answers: [
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks,
                title: 'Correct',
                text: question['answers'][0]['text'],
                comments: question['answers'][0]['comments_html'],
                blank_id: question['answers'][0]['blank_id']
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks,
                title: 'Correct',
                text: question['answers'][1]['text'],
                comments: question['answers'][1]['comments_html'],
                blank_id: question['answers'][1]['blank_id']
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks,
                title: 'Correct',
                text: question['answers'][2]['text'],
                comments: question['answers'][2]['comments_html'],
                blank_id: question['answers'][2]['blank_id']
              )
            ],
            distractors: []
          )
        end
      end
    end
  end

  describe '.from_markdown' do
    context 'with a multiple choice question' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question/multiple_choice.md')
        expect(described_class.from_markdown(input)).to have_attributes(
          course_id: 4091,
          quiz_id: 21962,
          id: 123906,
          type: 'multiple_choice_question',
          name: 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
          description: '<p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>',
          comment: '<p><strong>Source/s: <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565">Functions: Continued</a></strong></p>',
          answers: [
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::MultipleChoice,
              title: 'Correct',
              text: '<p>useHistory</p>',
              comments: ''
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::MultipleChoice,
              title: 'Incorrect',
              text: '<p>useParams</p>',
              comments: '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::MultipleChoice,
              title: 'Incorrect',
              text: '<p>useState</p>',
              comments: '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::MultipleChoice,
              title: 'Incorrect',
              text: '<p>I don&#39;t know.</p>',
              comments: '<p>Comment</p>'
            )
          ],
          distractors: []
        )
      end
    end

    context 'with a true/false question' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question/true_false.md')
        expect(described_class.from_markdown(input)).to have_attributes(
          course_id: 4091,
          quiz_id: 21962,
          id: 123906,
          type: 'true_false_question',
          name: 'Question 1',
          description: '<p>Answer true</p>',
          comment: '',
          answers: [
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::TrueFalse,
              title: 'Correct',
              text: 'True',
              comments: ''
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::TrueFalse,
              title: 'Incorrect',
              text: 'False',
              comments: ''
            )
          ],
          distractors: []
        )
      end
    end

    context 'with a matching question' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question/matching.md')
        expect(described_class.from_markdown(input)).to have_attributes(
          course_id: 4091,
          quiz_id: 21962,
          id: 144189,
          type: 'matching_question',
          name: 'Matching Question',
          description: '<p>Match the value on the left to the correct value from the dropdown.</p>',
          comment: '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
          answers: [
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::Matching,
              title: 'Correct',
              text: 'Answer 1',
              comments: '',
              left: 'Answer 1',
              right: 'Value 1',
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::Matching,
              title: 'Correct',
              text: 'Answer 2',
              comments: '',
              left: 'Answer 2',
              right: 'Value 2',
            )
          ],
          distractors: ['Incorrect 1', 'Incorrect 2']
        )
      end
    end

    context 'with a fill in multiple blanks question' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question/fill_in_multiple_blanks.md')
        expect(described_class.from_markdown(input)).to have_attributes(
          course_id: 3297,
          quiz_id: 12020,
          id: 130145,
          type: 'fill_in_multiple_blanks_question',
          name: 'Fundamentals: Logical Operators',
          description: "<p>How do we declare JavaScript&#39;s 3 logical operators?</p>\n\n<p>[value1] AND</p>\n\n<p>[value2] OR</p>\n\n<p>[value3] NOT</p>",
          comment: '<p><strong>Source/s:</strong> <a href="https://learning.flatironschool.com/courses/3297/pages/logical-operators?module_item_id=143560">Logical Operators</a></p>',
          answers: [
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks,
              title: 'Correct',
              text: '&&',
              comments: '<p>Nice one!</p>',
              blank_id: 'value1'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks,
              title: 'Correct',
              text: '"&&"',
              comments: '<p>Nice one!</p>',
              blank_id: 'value1'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks,
              title: 'Correct',
              text: '||',
              comments: '<p>Correct!</p>',
              blank_id: 'value2'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks,
              title: 'Correct',
              text: '"||"',
              comments: '<p>Correct!</p>',
              blank_id: 'value2'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks,
              title: 'Correct',
              text: '!',
              comments: '<p>Nailed it!</p>',
              blank_id: 'value3'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::FillInMultipleBlanks,
              title: 'Correct',
              text: '"!"',
              comments: '<p>Nailed it!</p>',
              blank_id: 'value3'
            )
          ],
          distractors: []
        )
      end
    end

    context 'with a multiple answers question' do
    end

    context 'with a code block in the description' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question/code_description.md')
        description = <<~HTML
          <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>

          <p>Take a <em>look</em> at this <strong>code</strong> :</p>
          <div class="highlight"><pre class="highlight jsx"><code><span class="kd">function</span> <span class="nx">hello</span><span class="p">()</span> <span class="p">{</span>
            <span class="k">return</span> <span class="dl">"</span><span class="s2">world</span><span class="dl">"</span><span class="p">;</span>
          <span class="p">}</span>
          </code></pre></div>
        HTML
        expect(described_class.from_markdown(input)).to have_attributes(
          course_id: 4091,
          quiz_id: 21962,
          id: 126509,
          type: 'multiple_choice_question',
          name: 'Functions: Scope',
          description: description.strip,
          comment: '<p><strong>Source/s:</strong> <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565">Functions: Continued</a></p>',
          answers: [
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer::MultipleChoice,
              title: 'Correct',
              text: '<p>This one!</p>',
              comments: '',
            )
          ],
          distractors: []
        )
      end
    end
  end

  describe '#to_markdown' do
    context 'with a multiple choice question' do
      it 'produces the correct markdown' do
        output = multiple_choice.to_markdown
        match = File.read('spec/fixtures/markdown/question/multiple_choice.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end

    context 'with a matching question' do
      it 'produces the correct markdown' do
        output = matching.to_markdown
        match = File.read('spec/fixtures/markdown/question/matching.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end

    context 'with a fill in multple blanks question' do
      it 'produces the correct markdown' do
        output = fill_in_multiple_blanks.to_markdown
        match = File.read('spec/fixtures/markdown/question/fill_in_multiple_blanks.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end

    context 'with a code block in the description' do
      it 'produces the correct markdown' do
        description = <<~HTML
          <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>

          <p>Take a <em>look</em> at this <strong>code</strong> :</p>
          <div class="highlight"><pre class="highlight jsx"><code><span class="kd">function</span> <span class="nx">hello</span><span class="p">()</span> <span class="p">{</span>
            <span class="k">return</span> <span class="dl">"</span><span class="s2">world</span><span class="dl">"</span><span class="p">;</span>
          <span class="p">}</span>
          </code></pre></div>
        HTML
        output = described_class.new(
          course_id: 4091,
          quiz_id: 21962,
          id: 126509,
          type: 'multiple_choice_question',
          name: 'Functions: Scope',
          description: description,
          comment: '<p><strong>Source/s:</strong> <a class="inline_disabled" href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565" target="_blank">Functions: Continued</a></p>',
          answers: [
            GithubToCanvasQuiz::Converter::Answer::MultipleChoice.new(
              title: 'Correct',
              text: '<p>This one!</p>',
              comments: ''
            )
          ],
          distractors: []
        ).to_markdown
        match = File.read('spec/fixtures/markdown/question/code_description.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end
  end

  describe '#to_h' do
    context 'with a multiple choice question' do
      it 'produces the correct hash' do
        output = multiple_choice.to_h
        expect(output).to eq({
          'question_name' => 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
          'question_text' => '<div><span>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</span></div>',
          'question_type' => 'multiple_choice_question',
          'points_possible' => 1,
          'neutral_comments_html' => '<p><strong>Source/s: <a class="inline_disabled" href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565" target="_blank">Functions: Continued</a></strong></p>',
          'answers' => multiple_choice.answers.map(&:to_h),
          'matching_answer_incorrect_matches' => ''
        })
      end
    end

    context 'with a matching question' do
      it 'produces the correct hash' do
        output = matching.to_h
        expect(output).to eq({
          'question_name' => 'Matching Question',
          'question_text' => '<p>Match the value on the left to the correct value from the dropdown.</p>',
          'question_type' => 'matching_question',
          'points_possible' => 1,
          'neutral_comments_html' => '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
          'answers' => matching.answers.map(&:to_h),
          'matching_answer_incorrect_matches' => "Incorrect 1\nIncorrect 2"
        })
      end
    end

    context 'with a true/false question' do
      it 'produces the correct hash' do
        output = true_false.to_h
        expect(output).to eq({
          'question_name' => 'Question 1',
          'question_text' => '<p>Answer true</p>',
          'question_type' => 'true_false_question',
          'points_possible' => 1,
          'neutral_comments_html' => '',
          'answers' => true_false.answers.map(&:to_h),
          'matching_answer_incorrect_matches' => ''
        })
      end
    end
  end
end
