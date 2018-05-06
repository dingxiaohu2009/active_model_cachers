require 'base_test'

class CacheAtBelongsToTest < BaseTest
  def test_basic_usage
    user = User.find_by(name: 'John1')
    language = user.language

    assert_queries(2){ assert_equal 'zh-tw', User.cacher_at(user.id).language.name }
    assert_queries(0){ assert_equal 'zh-tw', User.cacher_at(user.id).language.name }
    assert_cache('active_model_cachers_User_at_language_id_1' => 2, 'active_model_cachers_Language_2' => language)
  end

  # ----------------------------------------------------------------
  # ● Create
  # ----------------------------------------------------------------
  def test_create
    user = User.find_by(name: 'John4')

    assert_queries(1){ assert_nil User.cacher_at(user.id).language }
    assert_queries(0){ assert_nil User.cacher_at(user.id).language }
    assert_cache('active_model_cachers_User_at_language_id_4' => ActiveModelCachers::NilObject)

    language = Language.create(id: -1, user: user, name: 'ko')
    assert_cache({})

    assert_queries(2){ assert_equal 'ko', User.cacher_at(user.id).language.name }
    assert_queries(0){ assert_equal 'ko', User.cacher_at(user.id).language.name }
    assert_cache('active_model_cachers_User_at_language_id_4' => -1, 'active_model_cachers_Language_-1' => language)
  ensure
    language.delete if language
  end

  # ----------------------------------------------------------------
  # ● Update
  # ----------------------------------------------------------------
  def test_update_nothing
    user = User.find_by(name: 'John1')
    language = user.language

    assert_queries(2){ assert_equal 'zh-tw', User.cacher_at(user.id).language.name }
    assert_queries(0){ assert_equal 'zh-tw', User.cacher_at(user.id).language.name }
    assert_cache('active_model_cachers_User_at_language_id_1' => 2, 'active_model_cachers_Language_2' => language)

    language.save
    assert_cache('active_model_cachers_User_at_language_id_1' => 2, 'active_model_cachers_Language_2' => language)

    assert_queries(0){ assert_equal 'zh-tw', User.cacher_at(user.id).language.name }
    assert_cache('active_model_cachers_User_at_language_id_1' => 2, 'active_model_cachers_Language_2' => language)
  end

  def test_update
    user = User.find_by(name: 'John1')
    language = user.language

    assert_queries(2){ assert_equal 'zh-tw', User.cacher_at(user.id).language.name }
    assert_queries(0){ assert_equal 'zh-tw', User.cacher_at(user.id).language.name }
    assert_cache('active_model_cachers_User_at_language_id_1' => 2, 'active_model_cachers_Language_2' => language)

    language.update_attributes(name: 'ko')
    assert_cache("active_model_cachers_User_at_language_id_1" => 2)

    assert_queries(1){ assert_equal 'ko', User.cacher_at(user.id).language.name }
    assert_cache('active_model_cachers_User_at_language_id_1' => 2, 'active_model_cachers_Language_2' => language)
  ensure
    language.update_attributes(name: 'zh-tw')
  end

  # ----------------------------------------------------------------
  # ● Destroy
  # ----------------------------------------------------------------
  def test_destroy
    user = User.create(id: -1, name: 'Pearl')
    language = Language.create(id: -3, user: user, name: 'ne')

    assert_queries(2){ assert_equal 'ne', User.cacher_at(user.id).language.name }
    assert_queries(0){ assert_equal 'ne', User.cacher_at(user.id).language.name }
    assert_cache('active_model_cachers_User_at_language_id_-1' => -3, 'active_model_cachers_Language_-3' => language)

    language.destroy
    assert_cache('active_model_cachers_User_at_language_id_-1' => -3)

    assert_queries(1){ assert_nil User.cacher_at(user.id).language }
    assert_queries(0){ assert_nil User.cacher_at(user.id).language }
    assert_cache('active_model_cachers_User_at_language_id_-1' => -3, 'active_model_cachers_Language_-3' => ActiveModelCachers::NilObject)
  ensure
    user.delete
    language.delete
  end

  # ----------------------------------------------------------------
  # ● Delete
  # ----------------------------------------------------------------
  def test_destroy
    user = User.create(id: -1, name: 'Pearl')
    language = Language.create(id: -3, user: user, name: 'ne')

    assert_queries(2){ assert_equal 'ne', User.cacher_at(user.id).language.name }
    assert_queries(0){ assert_equal 'ne', User.cacher_at(user.id).language.name }
    assert_cache('active_model_cachers_User_at_language_id_-1' => -3, 'active_model_cachers_Language_-3' => language)

    language.delete
    assert_cache('active_model_cachers_User_at_language_id_-1' => -3)

    assert_queries(1){ assert_nil User.cacher_at(user.id).language }
    assert_queries(0){ assert_nil User.cacher_at(user.id).language }
    assert_cache('active_model_cachers_User_at_language_id_-1' => -3, 'active_model_cachers_Language_-3' => ActiveModelCachers::NilObject)
  ensure
    user.delete
    language.delete
  end
end
