require 'rails_helper'
require 'uri'
require 'net/http'

RSpec.describe Recipe, type: :model do
  
  user_api_key = ""
  user_email_id = "225926402801"
  contributor_api_key = ""
  contributor_email_id = "299041900332"
  recipe_id = 0

  describe "Signup", type: :request do
    it 'it signup new user' do
      header = {
        "Content-Type": "application/json",
      }
      body = {
        emai: "ahmad.fauzan1603@gmail.com",
        role: "contributor"
      }
      post(
        '/api/v1/signup',
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(201) 
    end 
  end

  describe "TOKEN Contributor", type: :request do
    it 'it should generate Conttributor token' do
      header = {
        "Content-Type": "application/json",
      }
      body = {
        email_id: contributor_email_id,
        otp: "1234567"
      }
      post(
        '/api/v1/verify',
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      contributor_api_key = json[:data][:token]
      expect(json[:meta][:status]).to eql(200) 
    end  

    it 'it should unauthorized user' do
      header = {
        "Content-Type": "application/json",
      }
      body = {
        email_id: contributor_email_id,
        otp: "1111111"
      }
      post(
        '/api/v1/verify',
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(401) 
    end 
  end

  describe "TOKEN User", type: :request do
    it 'it should generate User token' do
      header = {
        "Content-Type": "application/json",
      }
      body = {
        email_id: user_email_id,
        otp: "1234567"
      }
      post(
        '/api/v1/verify',
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      user_api_key = json[:data][:token]
      expect(json[:meta][:status]).to eql(200) 
    end  
  end

  describe "Search Recomendation 3rd party Contributor", type: :request do
    it 'Return Success' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      get(
        "/api/v1/recipe/search?keyword=Kafteji",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200) 
    end  
  end

  describe "Show Recomendation 3rd party Contributor", type: :request do
    it 'Return Success' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      get(
        "/api/v1/recipe/recomendation",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200) 
    end  
  end

  describe "Create Recipe", type: :request do
    it 'Return Success' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      body = {
        "name": "Indomie Goreng",
        "category": "side",
        "subcategory": "noodles",
        "national": "indonesia",
        "ingredients_attributes":[
            {
                "ingredient": "noodles",
                "measure": "1 pcs"
            },
            {
                "ingredient": "water",
                "measure": "1 litre"
            },
            {
                "ingredient": "seasoning",
                "measure": "1 pack"
            }
        ],
        "instructions_attributes":[
            {
                "instruction": "Heat the water until boils"
            },
            {
                "instruction": "Insert the noodles, wait 5 minutes"
            },
            {
                "instruction": "Open the seasoning and pour into the bowl"
            },
            {
                "instruction": "Pour the noodle into bowl, and mix well"
            }
        ]
      }
      post(
        "/api/v1/recipe/create",
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      recipe_id = json[:data][:id]
      expect(json[:meta][:status]).to eql(201) 
    end 
    
    it 'Return Bad Request' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      body = {
        "names": "Indomie Goreng"
      }
      post(
        "/api/v1/recipe/create",
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(400) 
    end 
    
    it 'Return Unauthorized User' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{user_api_key}"
      }
      body = {
        "name": "Indomie Goreng",
        "category": "side",
        "subcategory": "noodles",
        "national": "indonesia",
        "ingredients_attributes":[
            {
                "ingredient": "noodles",
                "measure": "1 pcs"
            },
            {
                "ingredient": "water",
                "measure": "1 litre"
            },
            {
                "ingredient": "seasoning",
                "measure": "1 pack"
            }
        ],
        "instructions_attributes":[
            {
                "instruction": "Heat the water until boils"
            },
            {
                "instruction": "Insert the noodles, wait 5 minutes"
            },
            {
                "instruction": "Open the seasoning and pour into the bowl"
            },
            {
                "instruction": "Pour the noodle into bowl, and mix well"
            }
        ]
      }
      post(
        "/api/v1/recipe/create",
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      recipe_id = json[:data][:id]
      expect(json[:meta][:status]).to eql(401) 
    end 
  end

  describe "Show All Recipe", type: :request do
    it 'Return Success' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      get(
        "/api/v1/recipe/show/all?page=1",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200) 
    end 
  end

  describe "Show All by ID", type: :request do
    it 'Return Success' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      get(
        "/api/v1/recipe/show/2",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(200) 
    end 

    it 'Return Not Found' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      get(
        "/api/v1/recipe/show/1",
        headers: header
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(404) 
    end 
  end

  describe "Update Recipe", type: :request do
    it 'Return Success' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      body = {
        "name": "Indomie Goreng",
        "category": "side",
        "subcategory": "noodles",
        "national": "indonesia",
        "ingredients_attributes":[
            {
                "ingredient": "noodles",
                "measure": "1 pcs"
            },
            {
                "ingredient": "water",
                "measure": "1 litre"
            },
            {
                "ingredient": "seasoning",
                "measure": "1 pack"
            }
        ],
        "instructions_attributes":[
            {
                "instruction": "Heat the water until boils"
            },
            {
                "instruction": "Insert the noodles, wait 5 minutes"
            },
            {
                "instruction": "Open the seasoning and pour into the bowl"
            },
            {
                "instruction": "Pour the noodle into bowl, and mix well"
            }
        ]
      }
      put(
        "/api/v1/recipe/update/2",
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      recipe_id = json[:data][:id]
      expect(json[:meta][:status]).to eql(200) 
    end 

    it 'Return Not Found' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      body = {
        "name": "Indomie Goreng",
        "category": "side",
        "subcategory": "noodles",
        "national": "indonesia",
        "ingredients_attributes":[
            {
                "ingredient": "noodles",
                "measure": "1 pcs"
            },
            {
                "ingredient": "water",
                "measure": "1 litre"
            },
            {
                "ingredient": "seasoning",
                "measure": "1 pack"
            }
        ],
        "instructions_attributes":[
            {
                "instruction": "Heat the water until boils"
            },
            {
                "instruction": "Insert the noodles, wait 5 minutes"
            },
            {
                "instruction": "Open the seasoning and pour into the bowl"
            },
            {
                "instruction": "Pour the noodle into bowl, and mix well"
            }
        ]
      }
      put(
        "/api/v1/recipe/update/1",
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(404) 
    end 
    
    it 'Return Bad Request' do
      header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer #{contributor_api_key}"
      }
      body = {
        "names": "Indomie Goreng"
      }
      put(
        "/api/v1/recipe/update/2",
        headers: header,
        params: body.to_json
      )
      json = JSON.parse(response.body).with_indifferent_access
      expect(json[:meta][:status]).to eql(400) 
    end 
  end

end
