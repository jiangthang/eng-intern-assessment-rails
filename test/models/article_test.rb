require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  test 'starts with no articles' do
    assert_equal 0, Article.count
  end

  test 'has search functionality' do
    assert_respond_to Article, :search
  end

  test 'creates a new article' do
    article = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.')
    assert article.valid?
  end

  test 'displays the article content accurately' do
    article = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.')
    assert_equal 'Lorem ipsum dolor sit amet.', article.content
  end

  test 'displays the article metadata correctly' do
    article = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.', author: 'John Doe', date: Date.today)
    assert_equal 'John Doe', article.author
    assert_equal Date.today, article.date
  end

  test 'edits an existing article' do
    article = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.')
    article.update(content: 'Updated content')
    assert_equal 'Updated content', article.content
  end

  test 'updates the article metadata' do
    article = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.', author: 'John Doe', date: Date.today)
    article.update(author: 'Jane Smith', date: Date.yesterday)
    assert_equal 'Jane Smith', article.author
    assert_equal Date.yesterday, article.date
  end

  test 'deletes an article' do
    article = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.')
    article.destroy
    assert_equal 0, Article.count
  end

  test 'prevents access to deleted articles' do
    article = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.')
    article.destroy
    assert_raises(ActiveRecord::RecordNotFound) { Article.find(article.id) }
  end

  test 'returns accurate search results' do
    article1 = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.')
    article2 = Article.create(title: 'Another Article', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
    results = Article.search('Lorem ipsum')
    assert_includes results, article1
    assert_includes results, article2
  end

  test 'displays relevant articles in search results' do
    article1 = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.')
    article2 = Article.create(title: 'Another Article', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
    results = Article.search('Another')
    assert_includes results, article2
    assert_not_includes results, article1
  end

  test 'sorts articles by title in ascending order' do
    article1 = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.')
    article2 = Article.create(title: 'Another Article', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
    results = Article.order(title: :asc)
    assert_equal results, [article2, article1] 
  end

  test 'sorts articles by title in descending order' do
    article1 = Article.create(title: 'Sample Article', content: 'Lorem ipsum dolor sit amet.')
    article2 = Article.create(title: 'Another Article', content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.')
    results = Article.order(title: :desc)
    assert_equal results, [article1, article2] 
  end

  test 'sorts articles by content in ascending order' do
    article1 = Article.create(title: 'Sample Article', content: 'A dog was here')
    article2 = Article.create(title: 'Another Article', content: 'Boat was here')
    results = Article.order(content: :asc)
    assert_equal results, [article1, article2] 
  end

  test 'sorts articles by content in descending order' do
    article1 = Article.create(title: 'Sample Article', content: 'A dog was here')
    article2 = Article.create(title: 'Another Article', content: 'Boat was here')
    results = Article.order(content: :desc)
    assert_equal results, [article2, article1] 
  end

  test 'sorts articles by author in ascending order' do
    article1 = Article.create(title: 'Another Article', content: 'Boat was here', author: 'Cartland')
    article2 = Article.create(title: 'Sample Article', content: 'A dog was here', author: 'Shakespeare')
    results = Article.order(author: :asc)
    assert_equal results, [article1, article2] 
  end

  test 'sorts articles by author in ascending order with missing author' do
    article1 = Article.create(title: 'Another Article', content: 'Boat was here')
    article2 = Article.create(title: 'Sample Article', content: 'A dog was here', author: 'Shakespeare')
    results = Article.order(author: :asc)
    assert_equal results, [article1, article2] 
  end

  test 'sorts articles by author in descending order' do
    article1 = Article.create(title: 'Another Article', content: 'Boat was here', author: 'Cartland')
    article2 = Article.create(title: 'Sample Article', content: 'A dog was here', author: 'Shakespeare')
    results = Article.order(author: :desc)
    assert_equal results, [article2, article1] 
  end

  test 'sorts articles by date in ascending order' do
    article1 = Article.create(title: 'Another Article', content: 'Boat was here', date: DateTime.new(2022, 1, 1))
    article2 = Article.create(title: 'Sample Article', content: 'A dog was here', date: DateTime.new(2022, 1, 2))
    articles = Article.order(date: :asc)
    assert_equal [article1, article2], articles
  end

  test 'sorts articles by date in ascending order with missing date' do
    article1 = Article.create(title: 'Another Article', content: 'Boat was here')
    article2 = Article.create(title: 'Sample Article', content: 'A dog was here', date: DateTime.new(2022, 1, 2))
    articles = Article.order(date: :asc)
    assert_equal [article1, article2], articles
  end

  test 'sorts articles by date in descending order' do
    article1 = Article.create(title: 'Another Article', content: 'Boat was here', date: DateTime.new(2022, 1, 1))
    article2 = Article.create(title: 'Sample Article', content: 'A dog was here', date: DateTime.new(2022, 1, 2))
    articles = Article.order(date: :desc)
    assert_equal [article2, article1], articles
  end

end
