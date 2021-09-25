# frozen_string_literal: true

RSpec.describe GithubToCanvasQuiz::MarkdownBuilder do
  let(:builder) { described_class.new }

  describe '#frontmatter' do
    it 'adds a frontmatter block' do
      builder.frontmatter({ 'id' => 1 })
      expect(builder.blocks).to include("---\nid: 1\n---")
    end
  end

  describe '#h1' do
    it 'adds a H1 block' do
      builder.h1('Hello')
      expect(builder.blocks).to include('# Hello')
    end
  end

  describe '#h2' do
    it 'adds a H2 block' do
      builder.h2('Hello')
      expect(builder.blocks).to include('## Hello')
    end
  end

  describe '#p' do
    it 'adds a paragraph block' do
      builder.p('World')
      expect(builder.blocks).to include('World')
    end
  end

  describe '#blockquote' do
    it 'adds a blockquote' do
      builder.blockquote('comment')
      expect(builder.blocks).to include('> comment')
    end

    it 'preserves newlines in blockquotes' do
      builder.blockquote("Line 1\nLine 2")
      expect(builder.blocks).to include("> Line 1\n> Line 2")
    end
  end

  describe '#ul' do
    it 'adds a list item' do
      builder.ul('item')
      expect(builder.blocks).to include('- item')
    end

    it 'adds multiple list items' do
      builder.ul('item 1', 'item 2')
      expect(builder.blocks).to include("- item 1\n- item 2")
    end
  end

  describe '#md' do
    it 'adds a block of arbitrary markdown' do
      builder.md("# Hello\n\nWorld\n")
      expect(builder.blocks).to include("# Hello\n\nWorld")
    end
  end

  describe '#to_s' do
    it 'returns a string of markdown by joining together the markdown blocks' do
      builder = described_class.new
      builder.h1('Hello')
      builder.p('World')
      expect(builder.to_s).to eq("# Hello\n\nWorld\n")
    end
  end

  describe '.build' do
    it 'creates a markdown string' do
      markdown = described_class.build do |md|
        md.h1('Hello')
        md.ul('item 1', 'item 2')
        md.blockquote('comment')
      end

      expect(markdown).to eq("# Hello\n\n- item 1\n- item 2\n\n> comment\n")
    end
  end
end
