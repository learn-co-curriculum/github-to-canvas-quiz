# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Parser::Markdown::Base do
  describe '#initialize' do
    context 'when given a string of markdown content' do
      it 'parses the markdown' do
        markdown = File.read('spec/fixtures/markdown/quiz.md')
        expect(described_class.new(markdown)).to have_attributes(
          frontmatter: {
            'id' => 18396,
            'course_id' => 4236,
            'repo' => 'phase-2-quiz-client-side-routing'
          },
          markdown: "# Client-Side Routing Quiz\n\nIt's time to check your knowledge!\n\nIf you don't know..\n"
        )
      end
    end

    context 'when given a path to a markdown file' do
      it 'reads the file and parses the markdown' do
        expect(described_class.new('spec/fixtures/markdown/quiz.md')).to have_attributes(
          frontmatter: {
            'id' => 18396,
            'course_id' => 4236,
            'repo' => 'phase-2-quiz-client-side-routing'
          },
          markdown: "# Client-Side Routing Quiz\n\nIt's time to check your knowledge!\n\nIf you don't know..\n"
        )
      end
    end
  end
end
