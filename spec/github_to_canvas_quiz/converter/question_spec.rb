# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Question do
  let(:multiple_choice) do
    described_class.new(
      id: 123906,
      type: 'multiple_choice_question',
      name: 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
      description: '<div><span>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</span></div>',
      comment: '<p><strong>Source/s: <a class="inline_disabled" href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565" target="_blank">Functions: Continued</a></strong></p>',
      answers: [
        GithubToCanvasQuiz::Converter::Answer.new(
          text: '<p>useHistory</p>',
          comments: '',
          left: '',
          right: '',
          title: 'Correct'
        ),
        GithubToCanvasQuiz::Converter::Answer.new(
          text: '<p>useParams</p>',
          comments: '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>',
          left: '',
          right: '',
          title: 'Incorrect'
        ),
        GithubToCanvasQuiz::Converter::Answer.new(
          text: '<p>useState</p>',
          comments: '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>',
          left: '',
          right: '',
          title: 'Incorrect'
        ),
        GithubToCanvasQuiz::Converter::Answer.new(
          text: '<p>I don&#39;t know.</p>',
          comments: '<p>Comment</p>',
          left: '',
          right: '',
          title: 'Incorrect'
        )
      ],
      distractors: []
    )
  end
  let(:matching) do
    described_class.new(
      id: 144189,
      type: 'matching_question',
      name: 'Matching Question',
      description: '<p>Match the value on the left to the correct value from the dropdown.</p>',
      comment: '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
      answers: [
        GithubToCanvasQuiz::Converter::Answer.new(
          text: 'Answer 1',
          comments: '',
          left: 'Answer 1',
          right: 'Value 1',
          title: 'Correct'
        ),
        GithubToCanvasQuiz::Converter::Answer.new(
          text: 'Answer 2',
          comments: '',
          left: 'Answer 2',
          right: 'Value 2',
          title: 'Correct'
        )
      ],
      distractors: ['Incorrect 1', 'Incorrect 2']
    )
  end
  let(:true_false) do
    described_class.new(
      id: 144189,
      type: 'true_false_question',
      name: 'Question 1',
      description: '<p>Answer true</p>',
      comment: '',
      answers: [
        GithubToCanvasQuiz::Converter::Answer.new(
          text: 'True',
          comments: '',
          left: '',
          right: '',
          title: 'Correct'
        ),
        GithubToCanvasQuiz::Converter::Answer.new(
          text: 'False',
          comments: '',
          left: '',
          right: '',
          title: 'Incorrect'
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
          question = client.get_single_question(4091, 21962, 144210)
          expect(described_class.from_canvas(question)).to have_attributes(
            id: question['id'],
            type: question['question_type'],
            name: question['question_name'],
            description: question['question_text'],
            comment: question['neutral_comments_html'],
            answers: [
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer,
                text: question['answers'][0]['html'],
                comments: question['answers'][0]['comments_html'],
                left: '',
                right: '',
                title: 'Correct'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer,
                text: question['answers'][1]['html'],
                comments: question['answers'][1]['comments_html'],
                left: '',
                right: '',
                title: 'Incorrect'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer,
                text: question['answers'][2]['html'],
                comments: question['answers'][2]['comments_html'],
                left: '',
                right: '',
                title: 'Incorrect'
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
          question = client.get_single_question(4091, 21962, 144243)
          expect(described_class.from_canvas(question)).to have_attributes(
            id: question['id'],
            type: question['question_type'],
            name: question['question_name'],
            description: question['question_text'],
            comment: question['neutral_comments_html'],
            answers: [
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer,
                text: question['answers'][0]['text'],
                comments: question['answers'][0]['comments_html'],
                left: question['answers'][0]['left'],
                right: question['answers'][0]['right'],
                title: 'Correct'
              ),
              have_attributes(
                class: GithubToCanvasQuiz::Converter::Answer,
                text: question['answers'][1]['text'],
                comments: question['answers'][1]['comments_html'],
                left: question['answers'][1]['left'],
                right: question['answers'][1]['right'],
                title: 'Correct'
              )
            ],
            distractors: ['Incorrect 1', 'Incorrect 2']
          )
        end
      end
    end
  end

  describe '.from_markdown' do
    context 'with a multiple choice question' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question_multiple_choice.md')
        expect(described_class.from_markdown(input)).to have_attributes(
          id: 123906,
          type: 'multiple_choice_question',
          name: 'By using which hook can we effectively navigate the user to a new page in response to any event in our application?',
          description: '<p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>',
          comment: '<p><strong>Source/s: <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565">Functions: Continued</a></strong></p>',
          answers: [
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: '<p>useHistory</p>',
              comments: '',
              left: '',
              right: '',
              title: 'Correct'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: '<p>useParams</p>',
              comments: '<p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>',
              left: '',
              right: '',
              title: 'Incorrect'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: '<p>useState</p>',
              comments: '<p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>',
              left: '',
              right: '',
              title: 'Incorrect'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: '<p>I don&#39;t know.</p>',
              comments: '<p>Comment</p>',
              left: '',
              right: '',
              title: 'Incorrect'
            )
          ],
          distractors: []
        )
      end
    end

    context 'with a true/false question' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question_true_false.md')
        expect(described_class.from_markdown(input)).to have_attributes(
          id: 123906,
          type: 'true_false_question',
          name: 'Question 1',
          description: '<p>Answer true</p>',
          comment: '',
          answers: [
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: 'True',
              comments: '',
              left: '',
              right: '',
              title: 'Correct'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: 'False',
              comments: '',
              left: '',
              right: '',
              title: 'Incorrect'
            )
          ],
          distractors: []
        )
      end
    end

    context 'with a matching question' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question_matching.md')
        expect(described_class.from_markdown(input)).to have_attributes(
          id: 144189,
          type: 'matching_question',
          name: 'Matching Question',
          description: '<p>Match the value on the left to the correct value from the dropdown.</p>',
          comment: '<p><strong>Source:</strong> <a href="https://learning.flatironschool.com/courses/4091/pages/a-quick-tour-of-the-web">A Quick Tour Of The Web</a></p>',
          answers: [
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: 'Answer 1',
              comments: '',
              left: 'Answer 1',
              right: 'Value 1',
              title: 'Correct'
            ),
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: 'Answer 2',
              comments: '',
              left: 'Answer 2',
              right: 'Value 2',
              title: 'Correct'
            )
          ],
          distractors: ['Incorrect 1', 'Incorrect 2']
        )
      end
    end

    context 'with a code block in the description' do
      it 'creates a Question instance with the correct data' do
        input = File.read('spec/fixtures/markdown/question_code_description.md')
        description = <<~HTML
          <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>

          <p>Take a <em>look</em> at this <strong>code</strong> :</p>
          <div class="highlight"><pre class="highlight jsx"><code><span class="kd">function</span> <span class="nx">hello</span><span class="p">()</span> <span class="p">{</span>
            <span class="k">return</span> <span class="dl">"</span><span class="s2">world</span><span class="dl">"</span><span class="p">;</span>
          <span class="p">}</span>
          </code></pre></div>
        HTML
        expect(described_class.from_markdown(input)).to have_attributes(
          id: 126509,
          type: 'multiple_choice_question',
          name: 'Functions: Scope',
          description: description.strip,
          comment: '<p><strong>Source/s:</strong> <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565">Functions: Continued</a></p>',
          answers: [
            have_attributes(
              class: GithubToCanvasQuiz::Converter::Answer,
              text: '<p>This one!</p>',
              comments: '',
              left: '',
              right: '',
              title: 'Correct'
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
        match = File.read('spec/fixtures/markdown/question_multiple_choice.md')
        expect(output.chomp).to eq(match.chomp)
      end
    end

    context 'with a matching question' do
      it 'produces the correct markdown' do
        output = matching.to_markdown
        match = File.read('spec/fixtures/markdown/question_matching.md')
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
          id: 126509,
          type: 'multiple_choice_question',
          name: 'Functions: Scope',
          description: description,
          comment: '<p><strong>Source/s:</strong> <a class="inline_disabled" href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565" target="_blank">Functions: Continued</a></p>',
          answers: [
            GithubToCanvasQuiz::Converter::Answer.new(
              text: '<p>This one!</p>',
              comments: '',
              left: '',
              right: '',
              title: 'Correct'
            )
          ],
          distractors: []
        ).to_markdown
        match = File.read('spec/fixtures/markdown/question_code_description.md')
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
          'answers' => multiple_choice.answers.map { |answer| answer.to_h('multiple_choice_question') },
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
          'answers' => matching.answers.map { |answer| answer.to_h('matching_question') },
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
          'answers' => true_false.answers.map { |answer| answer.to_h('true_false_question') },
          'matching_answer_incorrect_matches' => ''
        })
      end
    end
  end
end
