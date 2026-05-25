import pandas as pd
import ast
import json
# the goal of this is to make a json or a xml file that can be used in the cpp 
# the point of this is to make it better for c++ to digest into the runtime
# this is meant to be a compile time script that we can add data to from other scores 

class compilation:
    def __init__(self):
        self.mappings = {}
        self.name_id_map = {}
        self.id_counter = 0


    def save(self):
        this_map = {}
        this_map["data"] = self.mappings
        this_map["id_index"] = self.name_id_map
        # Saving to a file
        with open('data/markov_data.json', 'w') as json_file:
            json.dump(this_map, json_file, indent=4)
    


    # this is how we add to the mappings 
    def add_vector(self,vector):
        ls = ast.literal_eval(vector)
        print(f"parsing vector {ls}")
        for i in ls:

            if i not in self.name_id_map.keys():
                self.name_id_map[i] = self.id_counter
                self.id_counter += 1

            for j in ls:
                if j not in self.name_id_map.keys():
                    self.name_id_map[j] = self.id_counter
                    self.id_counter += 1

                if self.name_id_map[i] not in self.mappings.keys():
                    self.mappings[self.name_id_map[i]] = {}

                if i == j:
                    continue
                else:
                    if self.name_id_map[j] not in self.mappings[self.name_id_map[i]].keys():
                        self.mappings[self.name_id_map[i]][self.name_id_map[j]] = 1
                    else:
                        self.mappings[self.name_id_map[i]][self.name_id_map[j]] += 1



def main():
    data = pd.read_csv("data/recipes_ingredients.csv")
    comp = compilation()
    for i in data["ingredients"]:
        try:
            comp.add_vector(i)
        except Exception as e: 
            print(f"error: {e}")
    pass
    comp.save()

if __name__ == "__main__":
    main()