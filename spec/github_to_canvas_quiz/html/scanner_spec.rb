# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::HTML::Scanner do
  let(:html) do
    <<~HTML
      <h1>Question Name</h1>
      <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>
      <blockquote>
        <p>
          <strong>Source/s: <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565\">Functions: Continued</a></strong>
        </p>
      </blockquote>
      <h2>Correct</h2>
      <p>useHistory</p>
      <h2>Incorrect</h2>
      <p>useParams</p>
      <blockquote>
        <p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>
      </blockquote>
      <h2>Incorrect</h2>
      <p>useState</p>
      <blockquote>
        <p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>
      </blockquote>
      <h2>Incorrect</h2>
      <p>I don't know.</p>
      <blockquote>
        <p>Comment</p>
      </blockquote>
    HTML
  end

  let(:scanner) do
    described_class.from_html(html)
  end

  describe '#scan' do
    context 'when the current node matches the selector' do
      it 'returns the matched node' do
        expect(scanner.scan('h1').to_html).to eq('<h1>Question Name</h1>')
      end

      it 'updates the cursor position' do
        scanner.scan('h1')
        expect(scanner.cursor).to eq(1)
      end
    end

    context 'when the current node does not match the selector' do
      it 'returns nil' do
        expect(scanner.scan('h6')).to eq(nil)
      end

      it 'does not update the cursor position' do
        scanner.scan('h6')
        expect(scanner.cursor).to eq(0)
      end
    end
  end

  describe '#scan_until' do
    context 'when given a selector in the document' do
      it 'returns the nodes between the current cursor and the selector' do
        expected_html = <<~HTML
          <h1>Question Name</h1>
          <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>
          <blockquote>
            <p>
              <strong>Source/s: <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565\">Functions: Continued</a></strong>
            </p>
          </blockquote>
          <h2>Correct</h2>
        HTML
        expect(scanner.scan_until('h2').to_html.strip).to eq(expected_html.strip)
      end

      it 'updates the cursor position' do
        scanner.scan_until('h2')
        expect(scanner.cursor).to eq(7)
      end
    end

    context 'when given a selector not in the document' do
      it 'returns nil' do
        expect(scanner.scan_until('h6')).to eq(nil)
      end

      it 'does not update the cursor position' do
        scanner.scan_until('h6')
        expect(scanner.cursor).to eq(0)
      end
    end

    context 'when scanning from the middle of the document' do
      it 'returns the nodes between the current cursor and the selector' do
        expected_html = <<~HTML
          <p>useHistory</p>
          <h2>Incorrect</h2>
        HTML
        scanner.scan_until('h2')
        expect(scanner.scan_until('h2').to_html.strip).to eq(expected_html.strip)
      end
    end
  end

  describe '#scan_before' do
    context 'when given a selector in the document' do
      it 'returns the nodes between the current cursor and the selector' do
        expected_html = <<~HTML
          <h1>Question Name</h1>
          <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>
          <blockquote>
            <p>
              <strong>Source/s: <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565\">Functions: Continued</a></strong>
            </p>
          </blockquote>
        HTML
        expect(scanner.scan_before('h2').to_html.strip).to eq(expected_html.strip)
      end

      it 'updates the cursor position' do
        scanner.scan_before('h2')
        expect(scanner.cursor).to eq(6)
      end
    end

    context 'when given a selector not in the document' do
      it 'returns nil' do
        expect(scanner.scan_before('h6')).to eq(nil)
      end

      it 'does not update the cursor position' do
        scanner.scan_before('h6')
        expect(scanner.cursor).to eq(0)
      end
    end

    context 'when scanning from the middle of the document' do
      it 'returns the nodes between the current cursor and the selector' do
        expected_html = <<~HTML
          <h2>Correct</h2>
          <p>useHistory</p>
        HTML
        scanner.scan_before('h2')
        expect(scanner.scan_before('h2').to_html.strip).to eq(expected_html.strip)
      end
    end
  end

  describe '#scan_rest' do
    it 'returns the nodes between the current cursor and the selector' do
      expected_html = <<~HTML
        <h2>Correct</h2>
        <p>useHistory</p>
        <h2>Incorrect</h2>
        <p>useParams</p>
        <blockquote>
          <p>We use the <a href="https://reactrouter.com/web/api/Hooks/useparams"><code>useParams</code></a> hook to get the dynamic <code>params</code> from the URL.</p>
        </blockquote>
        <h2>Incorrect</h2>
        <p>useState</p>
        <blockquote>
          <p>We use the <a href="https://reactjs.org/docs/hooks-reference.html#usestate">useState</a> hook to return a stateful value, and a function to update it.</p>
        </blockquote>
        <h2>Incorrect</h2>
        <p>I don't know.</p>
        <blockquote>
          <p>Comment</p>
        </blockquote>
      HTML
      scanner.scan_before('h2')
      expect(scanner.scan_rest.to_html.strip).to eq(expected_html.strip)
    end

    it 'updates the cursor position' do
      scanner.scan_rest
      expect(scanner.cursor).to eq(scanner.node_set.length)
    end
  end

  describe '#check_until' do
    context 'when given a selector in the document' do
      it 'returns the nodes between the current cursor and the selector' do
        nodes = scanner.check_until('h2')
        html = <<~HTML
          <h1>Question Name</h1>
          <p>Which hook gives us the ability to programmatically navigate the user to a new page in our application?</p>
          <blockquote>
            <p>
              <strong>Source/s: <a href="https://learning.flatironschool.com/courses/3297/assignments/73913?module_item_id=143565\">Functions: Continued</a></strong>
            </p>
          </blockquote>
          <h2>Correct</h2>
        HTML
        expect(nodes.to_html.strip).to eq(html.strip)
      end

      it 'does not update the cursor position' do
        scanner.check_until('h2')
        expect(scanner.cursor).to eq(0)
      end
    end

    context 'when given a selector not in the document' do
      it 'returns nil' do
        expect(scanner.check_until('h6')).to eq(nil)
      end

      it 'does not update the cursor position' do
        scanner.check_until('h6')
        expect(scanner.cursor).to eq(0)
      end
    end
  end
end
