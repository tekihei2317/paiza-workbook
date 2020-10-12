require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '名前、メールアドレス、パスワードがあれば有効である' do
      user = User.new(
        name: 'tetsuma',
        email: 'tetsuma@example.com',
        password: 'hogefuga',
      )
      expect(user).to be_valid
    end

    context 'nameカラム' do
      it '存在しなければ無効である' do
        user = User.new(name: nil)
        user.valid?
        expect(user.errors[:name]).to include('を入力してください')
      end

      it '一意である(同じ名前のユーザーを複数登録できない)' do
        User.create(
          name: 'tetsuma',
          email: 'tetsuma@example.com',
          password: 'hogefuga',
        )
        user = User.new(
          name: 'tetsuma',
          email: 'tetsuma@example.com',
          password: 'hogefuga',
        )

        user.valid?
        expect(user.errors[:name]).to include('はすでに存在します')
      end
    end

    context 'emailカラム' do
      it '存在しなければ無効である' do
        user = User.new(email: nil)
        user.valid?
        expect(user.errors[:email]).to include('が入力されていません。')
      end
      it '一意である(同じメールアドレスのユーザーを複数登録できない)' do
        User.create(
          name: 'tetsuma',
          email: 'tetsuma@example.com',
          password: 'hogefuga',
        )
        user = User.new(
          name: 'tetsuma',
          email: 'tetsuma@example.com',
          password: 'hogefuga',
        )
        user.valid?
        expect(user.errors[:email]).to include('は既に使用されています。')
      end
    end
  end
end
