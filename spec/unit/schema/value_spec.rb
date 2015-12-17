RSpec.describe Schema::Value do
  subject(:value) { Schema::Value.new(:payments) }

  describe '#each' do
    it 'creates an each rule with another rule returned from the block' do
      rule = value.each do
        value.key?(:method)
      end

      expect(rule).to match_array(
        [:each, [
          :payments, [:val, [:payments, [:predicate, [:key?, [:method]]]]]]
        ]
      )
    end

    it 'creates an each rule with other rules returned from the block' do
      rule = value.each do
        value.key(:method) { |method| method.str? }
        value.key(:amount) { |amount| amount.float? }
      end

      expect(rule).to match_array(
        [:each, [
          :payments, [
            :set, [
              :payments, [
                [:and, [
                  [:key, [:method, [:predicate, [:key?, []]]]],
                  [:val, [:method, [:predicate, [:str?, []]]]]
                ]],
                [:and, [
                  [:key, [:amount, [:predicate, [:key?, []]]]],
                  [:val, [:amount, [:predicate, [:float?, []]]]]
                ]],
              ]
            ]
          ]
        ]]
      )
    end
  end
end