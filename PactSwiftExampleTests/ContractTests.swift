import Quick
import Nimble
import PactSwiftExample
import PactConsumerSwift

class ContractTests: QuickSpec {
    var seedProvider: MockService?
    var seedClient: SeedClient?

    override func spec() {
        describe("Client Contract Tests") {

            beforeEach {
                self.seedProvider = MockService(provider: "Seed Provider", consumer: "Seed Consumer")
                self.seedClient = SeedClient(baseUrl: self.seedProvider!.baseUrl)
            }

            it ("gets some seeds with 200") {
                self.seedProvider!
                    .given("there are seeds")
                    .uponReceiving("a request for seeds")
                    .withRequest(method:.GET, path: "/seeds")
                    .willRespondWith(status: 200, headers: ["Content-Type": "application/json"],
                                     body: ["seeds": "some seeds"]
                    )

                self.seedProvider!.run {
                    (testComplete) -> Void in
                    self.seedClient!.getSeeds { (response) in
                        expect(response).to(equal("some seeds"))
                        testComplete()
                    }
                }
            }

            it ("does not find seeds") {
                self.seedProvider!
                    .given("there are no seeds")
                    .uponReceiving("a request for seeds")
                    .withRequest(method:.GET, path: "/seeds")
                    .willRespondWith(status: 404, headers: ["Content-Type": "application/json"],
                                     body: ["error": "not found"]
                )

                self.seedProvider!.run {
                    (testComplete) -> Void in
                    self.seedClient!.getSeeds { (response) in
                        expect(response).to(equal("not found"))
                        testComplete()
                    }
                }
            }
        }
    }
}
