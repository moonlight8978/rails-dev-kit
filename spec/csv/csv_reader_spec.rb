class MemberCsv
  include DevKit::Csv::CsvRowRecord
  extend DevKit::Csv::CsvRowRecord

  column :id, header: "Id", converter: :integer
  column :name, header: "Name", converter: :string
  column :groups, header: "Group", converter: :array_of_string
end

class MemberAttachmentCsv
  include DevKit::Csv::CsvRowRecord
  extend DevKit::Csv::CsvRowRecord

  column :id, header: "Attachment Id", converter: :integer
  column :name, header: "Attachment Name", converter: :string
end

class GroupMemberCsv
  include DevKit::Csv::CsvRowRecord
  extend DevKit::Csv::CsvRowRecord

  column :id, header: "Member Id", converter: :integer
  column :name, header: "Member Name", converter: :string
  column :attachments, sub_reader: MemberAttachmentCsv
end

class GroupCsv
  include DevKit::Csv::CsvRowRecord
  extend DevKit::Csv::CsvRowRecord

  column :id, header: "Group Id", converter: :integer
  column :name, header: "Group Name", converter: :string
  column :members, sub_reader: GroupMemberCsv
end

RSpec.describe DevKit::Csv::CsvReader do
  context "flat csv" do
    it "reads csv correctly" do
      results = []

      described_class.foreach(file: "spec/fixtures/flat-csv.csv", type: MemberCsv) do |member|
        results << member
      end

      expect(results).to have(3).items

      expect(results[0].id).to eq(1)
      expect(results[0].name).to eq("Le Si Bich")
      expect(results[0].groups).to eq(["Gr1", "Gr2", "Gr3"])

      expect(results[1].id).to eq(2)
      expect(results[1].name).to eq("Luu Xuan Viet")
      expect(results[1].groups).to eq([])

      expect(results[2].id).to eq(3)
      expect(results[2].name).to eq("Hoang Thu Huong")
      expect(results[2].groups).to eq(["Gr1"])
    end
  end

  context "multi-level csv" do
    it "reads csv correctly" do
      results = []

      described_class.foreach(file: "spec/fixtures/multi-level-csv.csv", type: GroupCsv) do |group|
        results << group
      end

      expect(results).to have(2).items

      group1, group2 = results

      expect(group1.id).to eq(1)
      expect(group1.name).to eq("Dan den")
      expect(group1.members).to have(2).items
      member1, member2 = group1.members

      expect(member1.id).to eq(10)
      expect(member1.name).to eq("Le Si Bich")
      expect(member1.attachments).to have(2).items
      attachment1, attachment2 = member1.attachments
      expect(attachment1.id).to eq(100)
      expect(attachment1.name).to eq("Le Sy Minh")
      expect(attachment2.id).to eq(101)
      expect(attachment2.name).to eq("Le Minh Ngoc")

      expect(member2.id).to eq(11)
      expect(member2.name).to eq("Luu Xuan Viet")
      expect(member2.attachments).to have(1).items
      attachment3 = member2.attachments[0]
      expect(attachment3.id).to eq(102)
      expect(attachment3.name).to eq("Tran Thi Trang")

      expect(group2.id).to eq(2)
      expect(group2.name).to eq("Sep")
      expect(group2.members).to have(2).items
      member3, member4 = group2.members

      expect(member3.id).to eq(12)
      expect(member3.name).to eq("Mai Ngoc Quang")
      expect(member3.attachments).to have(1).items
      attachment4 = member3.attachments[0]
      expect(attachment4.id).to eq(103)
      expect(attachment4.name).to eq("Mai Ngoc Thinh")

      expect(member4.id).to eq(13)
      expect(member4.name).to eq("Hoa Van Luong")
      expect(member4.attachments).to have(1).items
      attachment5 = member4.attachments[0]
      expect(attachment5.id).to eq(104)
      expect(attachment5.name).to eq("Do Dinh Tuan")
    end
  end
end
