require 'rails_helper'

RSpec.describe Spree::Api::PromotionsController, type: :request do
  let!(:promotions) { create_list(:promotion, 5) }
  let(:promotion_id) { promotions.first.id }
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }
  
  let(:valid_attributes) do
    {
      promotion: {
        name: "Summer Sale",
        description: "Discounts on all summer items",
        conditions: { 
          line_items: ["test"] 
        }
      }
    }.to_json
  end

  
  let(:invalid_attributes) do
    {
      promotion: {
        name: nil,
        description: "Invalid promotion without a name",
        conditions: { 
          line_items: [] 
        }
      }
    }.to_json
  end

  describe "GET /api/promotions" do
    before { get "/api/promotions", headers: headers }

    it "returns promotions" do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /api/promotions/:id" do
    context "when the record exists" do
      before { get "/api/promotions/#{promotion_id}", headers: headers }

      it "returns the promotion" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(promotion_id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the record does not exist" do
      let(:promotion_id) { 100 }

      before { get "/api/promotions/#{promotion_id}", headers: headers }

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Promotion/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /api/promotions" do
    context "when the request is valid" do
      before { post "/api/promotions", params: valid_attributes, headers: headers }

      it "creates a promotion" do
        expect(json["name"]).to eq("Summer Sale")
        expect(json["description"]).to eq("Discounts on all summer items")
        expect(json["conditions"]).to eq({ 
          "line_items" => ["test"] 
        })
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid" do
      before { post "/api/promotions", params: invalid_attributes, headers: headers }

      it "returns a validation failure message" do
        expect(json["name"]).to include("can't be blank")
      end

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PUT /api/promotions/:id" do
    let(:valid_update_attributes) do
      {
        promotion: {
          name: "Winter Sale",
          description: "Discounts on all winter items",
          conditions: {
            line_items: []
          }
        }
      }.to_json
    end

    context "when the record exists" do
      before { put "/api/promotions/#{promotion_id}", params: valid_update_attributes, headers: headers }

      it "updates the record" do
        expect(json["name"]).to eq("Winter Sale")
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the record does not exist" do
      let(:promotion_id) { 100 }
      before { put "/api/promotions/#{promotion_id}", params: valid_attributes, headers: headers }

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Promotion/)
      end

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "PATCH /api/promotions/:id" do
    let(:valid_attributes) { { description: "Updated description" }.to_json }

    context "when the record exists" do
      before { patch "/api/promotions/#{promotion_id}", params: valid_attributes, headers: headers }

      it "updates the record" do
        expect(json["description"]).to eq("Updated description")
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /api/promotions/:id" do
    before { delete "/api/promotions/#{promotion_id}", headers: headers }

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end

    it "actually deletes the record" do
      expect { Promotion.find(promotion_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET /api/promotions/new" do
    before { get "/api/promotions/new", headers: headers }

    it "returns status code 200" do
      expect(response).to have_http_status(204)
    end
  end

  # Helper method to parse JSON responses
  def json
    JSON.parse(response.body)
  end
end
