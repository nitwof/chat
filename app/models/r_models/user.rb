module RModels

  class User

    attr_accessor :id, :ip, :name, :gender, :age, :location

    TABLE_ALLOWED = 'allowed'
    TABLE_BLOCKED = 'blocked'

    class << self

      # get all by room id
      def allowed(rid)
        allowed = {}
        sallowed = $redis.hkeys "#{TABLE_ALLOWED}:#{rid}"
        sallowed.each do |id|
          juser = JSON.parse($redis.hget "#{TABLE_ALLOWED}:#{rid}", id)
          allowed[id] = new(id: id, name: juser['name'], ip: juser['ip'], 
                          gender: juser['gender'], age: juser['age'], location: juser['location'])
        end
        return allowed
      end

      def allowed_json(rid)
        allowed = {}
        sallowed = $redis.hkeys "#{TABLE_ALLOWED}:#{rid}"
        sallowed.each do |id|
          allowed[id] = JSON.parse($redis.hget "#{TABLE_ALLOWED}:#{rid}", id)
        end
        return allowed
      end

      def allowed_plain(rid)
        allowed = {}
        sallowed = $redis.hkeys "#{TABLE_ALLOWED}:#{rid}"
        sallowed.each do |key|
          allowed[key] = $redis.hget "#{TABLE_ALLOWED}:#{rid}", key
        end
        return allowed
      end

      def allowed_ids(rid)
        $redis.hkeys "#{TABLE_ALLOWED}:#{rid}"
      end

    end

    def initialize(options={})
      @id = options.fetch :id, SecureRandom.hex(5)
      @ip = options.fetch :ip
      @name = options.fetch :name
      @gender = options[:gender]
      @age = options[:age]
      @location = options[:location]
    end

    def allow(rid)
      $redis.hset "#{TABLE_ALLOWED}:#{rid}", @id, to_json
    end

    def to_json
      JSON.generate ip: @ip, name: @name, gender: @gender, age: @age, location: @location
    end
  end

end