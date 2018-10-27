/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.submit.step;

import java.util.Comparator;
import org.dspace.content.Item;

/**
 *
 * @author john
 */
public class ItemSortByName implements Comparator<Item>
{
	@Override
	public int compare(Item a, Item b)
	{
		return a.getName().compareToIgnoreCase(b.getName());
	}
}
