RSpec.describe Schema::Key do
  include_context 'predicate helper'

  let(:registry) { PredicateRegistry.new(predicates) }

  describe '#str?' do
    subject(:user) { Schema::Key[:user, registry: registry] }

    it 'returns a key rule' do
      expect(user.str?.to_ast).to eql([:key, [:user, p(:str?)]])
    end

    it 'returns a key rule & disjunction rule created within the block' do
      user.hash? do
        required(:email) { none? | filled? }
      end

      expect(user.to_ast).to eql([
        :key, [:user, [
          :and, [
            [:val, p(:hash?)],
            [:key, [:user, [:and, [
              [:val, p(:key?, :email)],
              [:or, [[:key, [:email, p(:none?)]], [:key, [:email, p(:filled?)]]]
            ]]]]]
          ]
        ]]
      ])
    end
  end
end
