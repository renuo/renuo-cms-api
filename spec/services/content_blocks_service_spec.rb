# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ContentBlocksService do
  describe '#all' do
    it 'returns an empty array when no records are found' do
      content_blocks = ContentBlocksService.new('x3vs').all
      expect(content_blocks).to eq([])
    end

    it 'returns an array of matching records' do
      cb1 = create(:content_block, api_key: 'x3vs')
      cb2 = create(:content_block, api_key: 'different')
      cb3 = create(:content_block, api_key: 'x3vs')
      content_blocks = ContentBlocksService.new('x3vs').all
      expect(content_blocks.size).to eq(2)
      expect(content_blocks).to include(cb1)
      expect(content_blocks).not_to include(cb2)
      expect(content_blocks).to include(cb3)
    end
  end

  describe '#find_or_initialize' do
    it 'initializes a new content block' do
      content_block = ContentBlocksService.new('x3vs').find_or_initialize('my-path')
      expect(content_block.new_record?).to be_truthy
      expect(content_block.content).to eq('')
      expect(content_block.content_path).to eq('my-path')
      expect(content_block.api_key).to eq('x3vs')
    end

    it 'checks whether a content_blocks content can be edited' do
      existing = create(:content_block)
      content_block = ContentBlocksService.new(existing.api_key).find_or_initialize(existing.content_path)
      expect(content_block.new_record?).to be_falsey
      expect(content_block.content).to eq(existing.content)
      expect(content_block.content_path).to eq(existing.content_path)
      expect(content_block.api_key).to eq(existing.api_key)
    end

    it 'returns a new content block when the api key does not exist' do
      existing = create(:content_block)
      content_block = ContentBlocksService.new('x3vs').find_or_initialize(existing.content_path)
      expect(content_block.new_record?).to be_truthy
      expect(content_block.content).to eq('')
      expect(content_block.content_path).to eq(existing.content_path)
      expect(content_block.api_key).to eq('x3vs')
    end

    it 'returns a new content block when the content path does not exist' do
      existing = create(:content_block)
      content_block = ContentBlocksService.new(existing.api_key).find_or_initialize('new-path')
      expect(content_block.new_record?).to be_truthy
      expect(content_block.content).to eq('')
      expect(content_block.content_path).to eq('new-path')
      expect(content_block.api_key).to eq(existing.api_key)
    end
  end

  describe '#outdated?' do
    subject { ContentBlocksService.new('cbs_outdated_test') }

    outdated_version = nil
    latest_version = nil

    before(:each) do
      block = create(:content_block, content_path: 'path_xy', api_key: 'cbs_outdated_test')
      outdated_version = block.version
      block.update(content: 'New version')
      latest_version = block.version
    end

    it 'returns true, if the given version does not match the latest version' do
      expect(subject.outdated?('path_xy', outdated_version)).to eq(true)
    end

    it 'returns false, if the given version matches the latest version' do
      expect(subject.outdated?('path_xy', latest_version)).to eq(false)
    end

    it 'returns false, if no version is given' do
      expect(subject.outdated?('path_xy', nil)).to eq(false)
    end
  end

  describe '#create_or_update' do
    it 'creates a new content block' do
      expect do
        content_block = ContentBlocksService.new('x3vs').create_or_update('my-path', content: 'new content')
        expect(content_block.content_path).to eq('my-path')
        expect(content_block.content).to eq('new content')
        expect(content_block.api_key).to eq('x3vs')
      end.to change { ContentBlock.count }.by(1)
    end

    it 'updates the content of an existing content block' do
      existing = create(:content_block)
      expect(existing.content).not_to eq('Z')
      expect do
        content_block = ContentBlocksService.new(existing.api_key).create_or_update(existing.content_path, content: 'Z')
        expect(content_block.api_key).to eq(existing.api_key)
        expect(content_block.content_path).to eq(existing.content_path)
        expect(content_block.content).to eq('Z')
      end.not_to change { ContentBlock.count }
    end
  end

  describe '#unhashed_etag' do
    def create_block_at(time, api_key)
      Timecop.freeze time do
        create(:content_block, api_key: api_key)
      end
    end

    it 'returns the last modified content_block of the given api_key' do
      # Rounding necessary because Ruby Time is more precise than DB time
      # See http://blog.solanolabs.com/rails-time-comparisons-devil-details-etc/
      last_week = 1.week.ago.round(6)
      today = 1.hour.ago.round(6)
      yesterday = 1.day.ago.round(6)

      content_block_service = ContentBlocksService.new('x3vs')
      expect(content_block_service.unhashed_etag).to eq(['x3vs', nil])

      create_block_at(last_week, 'x3vs')
      expect(content_block_service.unhashed_etag).to eq(['x3vs', last_week])

      create_block_at(today, 'different')
      expect(content_block_service.unhashed_etag).to eq(['x3vs', last_week])

      create_block_at(yesterday, 'x3vs')
      expect(content_block_service.unhashed_etag).to eq(['x3vs', yesterday])
    end
  end
end
