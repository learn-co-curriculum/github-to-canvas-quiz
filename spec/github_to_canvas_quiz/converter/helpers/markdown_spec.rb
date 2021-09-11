# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::Converter::Helpers::Markdown do
  let(:converter) do
    Class.new { include GithubToCanvasQuiz::Converter::Helpers::Markdown }.new
  end

  describe '#frontmatter' do
    it 'produces the correct markdown' do
      output = "---\nid: 1234\ntype: matching\n---"
      expect(converter.frontmatter({
        'id' => 1234,
        'type' => 'matching'
      })).to eq(output)
    end
  end

  describe '#h1' do
    it 'produces the correct markdown' do
      expect(converter.h1('test')).to eq('# test')
    end
  end

  describe '#h2' do
    it 'produces the correct markdown' do
      expect(converter.h2('test')).to eq('## test')
    end
  end

  describe '#ul' do
    it 'produces the correct markdown' do
      expect(converter.ul('one', 'two')).to eq("- one\n- two")
    end
  end

  describe '#li' do
    it 'produces the correct markdown' do
      expect(converter.li('one')).to eq('- one')
    end
  end

  describe '#blockquote' do
    context 'with a single line input' do
      it 'produces the correct markdown' do
        expect(converter.blockquote('one')).to eq('> one')
      end
    end

    context 'with input containing HTML' do
      it 'produces the correct markdown' do
        input = '<p><span>We use the <a class="external" href="https://reactrouter.com/web/api/Hooks/useparams" target="_blank"><code>useParams</code><span class="screenreader-only">&nbsp;(Links to an external site.)</span></a> hook to get the dynamic </span><code>params</code><span> from the URL.</span></p>'
        expect(converter.blockquote(input)).to eq('> We use the [`useParams`](https://reactrouter.com/web/api/Hooks/useparams) hook to get the dynamic `params` from the URL.')
      end
    end

    context 'with a multi-line HTML input' do
      it 'produces the correct markdown' do
        input = "<p>Paragraph</p><pre><code>function code() {\n  return 'ok'\n}\n</code></pre>"
        output = "> Paragraph\n> \n> ```\n> function code() {\n>   return 'ok'\n> }\n> ```"
        expect(converter.blockquote(input)).to eq(output)
      end
    end
  end

  describe '#escape' do
    it 'escapes markdown characters in text strings' do
      expect(converter.escape('___')).to eq('\_\_\_')
    end
  end

  describe '#markdown_block' do
    it 'converts html to markdown' do
      input = "<p>Paragraph</p><pre><code>function code() {\n  return 'ok'\n}\n</code></pre>"
      output = "Paragraph\n\n```\nfunction code() {\n  return 'ok'\n}\n```\n"
      expect(converter.markdown_block(input)).to eq(output)
    end
  end
end
