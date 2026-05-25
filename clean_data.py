import pandas as pd
def main():
    data = pd.read_csv("data/recipes_ingredients.csv")
    data["ingredients"].to_csv("data/clean.csv",index=False)

if __name__ == "__main__":
    main()