require 'rails_helper'

RSpec.describe TrackableEntriesController, type: :controller do
  # This controller is abstract, so we'll test it through a concrete subclass
  # But we can test the abstract methods directly
  
  controller(TrackableEntriesController) do
    # Create a minimal concrete implementation for testing
    def model_class
      FoodEntry
    end

    def entry_params
      params.require(:food_entry).permit(:description, :consumed_at, :notes)
    end

    def default_path
      food_entries_path
    end

    def entry_variable_name
      'food_entry'
    end

    def timestamp_column
      :consumed_at
    end

    def model_name
      'Food entry'
    end
  end

  describe 'abstract methods' do
    it 'raises NotImplementedError for model_class when not implemented' do
      # Create a controller that doesn't implement model_class
      controller_class = Class.new(TrackableEntriesController) do
        # Don't implement model_class
      end
      
      expect {
        controller_class.new.send(:model_class)
      }.to raise_error(NotImplementedError, /Subclass must implement model_class/)
    end

    it 'raises NotImplementedError for entry_params when not implemented' do
      controller_class = Class.new(TrackableEntriesController) do
        def model_class
          FoodEntry
        end
        # Don't implement entry_params
      end
      
      expect {
        controller_class.new.send(:entry_params)
      }.to raise_error(NotImplementedError, /Subclass must implement entry_params/)
    end

    it 'raises NotImplementedError for default_path when not implemented' do
      controller_class = Class.new(TrackableEntriesController) do
        def model_class
          FoodEntry
        end
        def entry_params
          {}
        end
        # Don't implement default_path
      end
      
      expect {
        controller_class.new.send(:default_path)
      }.to raise_error(NotImplementedError, /Subclass must implement default_path/)
    end

    it 'raises NotImplementedError for entry_variable_name when not implemented' do
      controller_class = Class.new(TrackableEntriesController) do
        def model_class
          FoodEntry
        end
        def entry_params
          {}
        end
        def default_path
          food_entries_path
        end
        # Don't implement entry_variable_name
      end
      
      expect {
        controller_class.new.send(:entry_variable_name)
      }.to raise_error(NotImplementedError, /Subclass must implement entry_variable_name/)
    end

    it 'raises NotImplementedError for timestamp_column when not implemented' do
      controller_class = Class.new(TrackableEntriesController) do
        def model_class
          FoodEntry
        end
        def entry_params
          {}
        end
        def default_path
          food_entries_path
        end
        def entry_variable_name
          'food_entry'
        end
        # Don't implement timestamp_column
      end
      
      expect {
        controller_class.new.send(:timestamp_column)
      }.to raise_error(NotImplementedError, /Subclass must implement timestamp_column/)
    end

    it 'raises NotImplementedError for model_name when not implemented' do
      controller_class = Class.new(TrackableEntriesController) do
        def model_class
          FoodEntry
        end
        def entry_params
          {}
        end
        def default_path
          food_entries_path
        end
        def entry_variable_name
          'food_entry'
        end
        def timestamp_column
          :consumed_at
        end
        # Don't implement model_name
      end
      
      expect {
        controller_class.new.send(:model_name)
      }.to raise_error(NotImplementedError, /Subclass must implement model_name/)
    end
  end

  describe '#prepopulate_date' do
    it 'returns early when entry instance variable is not set' do
      # This tests the `return unless entry` path
      # When prepopulate_date is called as a before_action before the instance variable is set
      allow(controller).to receive(:params).and_return({ date: '2024-01-01' })
      controller.instance_variable_set(:@food_entry, nil)
      
      # Should not raise an error, just return early
      expect { controller.send(:prepopulate_date) }.not_to raise_error
    end
  end
end

