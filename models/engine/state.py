#!/usr/bin/python3
"""State module"""

from models.base_model import BaseModel
from models.city import City

class State(BaseModel):
    """State class"""

    def __init__(self, *args, **kwargs):
        """Initialize State instance"""
        super().__init__(*args, **kwargs)
        self.name = ""

    # Getter method to retrieve cities linked to the current state
    @property
    def cities(self):
        """Getter method for cities"""
        from models import storage
        city_list = []
        for city in storage.all(City).values():
            if city.state_id == self.id:
                city_list.append(city)
        return city_list
